const express = require("express");
const bodyParser = require('body-parser');
var request=require('request');
var generador_jwt=require('./src/jwt/jwt.js');
var conexionbd=require('./src/conexionbd/conexionbd.js');
const app = express();
app.use(express.static('src')); 
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
conexionbd.client.connect();
app.post('/auth', function (req, res) {
    var idusuario=req.body.idusuario;
    var carne=req.body.carne;
    var nombre=req.body.nombre;
    var cod_respuesta='';
    if(idusuario==null||carne==null||nombre==null){
        cod_respuesta="{'codigo':'400','mensaje':'Parametros null'}";
        res.send(cod_respuesta);
    }else{
        verificarInformacion(idusuario)
        .then(function(verificar){
            if(verificar){
                var payload={
                    auth:true,
                    idusuario:idusuario
                };
                var token=generarToken(payload);
                res.send(token);
            }else{
                console.log('tenemos que registrar al usuario');
                res.send('tenemos que registrar al usuario');
                //no se encuentra registrado en el sistema
                //lo vamos a registrar y vamos a retornar el jwt necesario
            }
        });
    }
});

app.post('/verificartoken',function(req,res){
    generador_jwt.verificarToken(req.body.token)
    .then(function(respuesta){
        res.send(respuesta);
    });
});

function generarToken(payload){
    var token=generador_jwt.jwt.sign(payload,generador_jwt.privateKEY,generador_jwt.signOptions);
    return token;
}

async function verificarInformacion(idusuario){
    const res=await conexionbd.client.query('select * from usuario where idusuario=$1',[idusuario])
    .then(res=>{
        if(res.rows.length==1){
            return true;
        }
        return false;
    }).catch(e=>{
        return false;
    });
    return res;
}
app.listen(3000,'0.0.0.0', () => {
    console.log("Servidor APP AlertaUSAC en la direccion 0.0.0.0:3000");
});