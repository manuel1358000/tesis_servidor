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
    var url=req.body.url;
    var rol=req.body.rol;
    if((url!=null||rol!='')||(rol!=null)){
        if(rol=='INVITADO'){
            var payload={
                auth:true,
                idusuario:'0',
                rol:rol
            };
            var token=generarToken(payload);
            res.send('{"codigo":"200","mensaje":"OK","data":{"token":"'+token+'","nombre":"INVITADO","url":""}}');
        }else{
            var idusuario='123456001';
            var carne='201213580';
            var nombre='Manuel Fuentes';
            var cod_respuesta='';  
            if(idusuario!=''){
                verificarInformacion(idusuario)
                .then(function(verificar){
                    if(verificar){
                        var payload={
                            auth:true,
                            idusuario:idusuario,
                            rol:rol
                        };
                        var token=generarToken(payload);
                        console.log('Cod: 200 Mensaje: Usuario Existente');
                        res.send('{"codigo":"200","mensaje":"OK","data":{"token":"'+token+'","nombre":"'+nombre+'","url":"'+url+'"}}');
                    }else{
                        registrarUsuarios(idusuario,carne,nombre,rol)
                        .then(function(respuesta){
                            if(respuesta){
                                var payload={
                                    auth:true,
                                    idusuario:idusuario,
                                    rol:rol
                                };
                                console.log('Cod: 200 Mensaje: Usuario Registrado');
                                var token=generarToken(payload);
                                res.send('{"codigo":"200","mensaje":"OK","data":{"token":"'+token+'","nombre":"'+nombre+'","url":"'+url+'"}}');
                            }else{
                                console.log('Cod: 500 Mensaje: Error al registrar usuario');
                                cod_respuesta='{"codigo":"400","mensaje":"Error al registrar usuarios"}';
                                res.send(cod_respuesta);
                            }
                        });
                    }
                });
            }else{
                cod_respuesta='{"codigo":"400","mensaje":"Parametros null"}';
                res.send(cod_respuesta);
            }
        }
    }else{
        cod_respuesta='{"codigo":"400","mensaje":"Parametros null"}';
        res.send(cod_respuesta);
    }
});

app.get('/prueba',function(req,res){
    var cod_respuesta='{"codigo":"400","mensaje":"Parametros null"}';
    res.send(cod_respuesta);
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

async function registrarUsuarios(idusuario,carne,nombre,rol){
    if((carne==null||carne==null)||(nombre==null||nombre==null)){
        console.log(rol);
        return false;
    }else{
        if(rol=='ADMINISTRADOR'||rol=='USUARIO'){
            var query="insert into usuario(idusuario,carne,nombre,rol)values('"+idusuario+"','"+carne+"','"+nombre+"','"+rol+"')";
            const res=await conexionbd.client.query(query)
            .then(res=>{
                console.log(res);
                return true;
            }).catch(e=>{
                console.log('Cod: 501 Mensaje: '+e);
                return false;
            });
            return res;
        }else{
            return false;
        }
    }
}

async function verificarInformacion(idusuario){
    const res=await conexionbd.client.query('select * from usuario where idusuario=$1',[idusuario])
    .then(res=>{
        if(res.rows.length==1){
            return true;
        }
        return false;
    }).catch(e=>{
        console.log('Cod: 501 Mensaje: '+e);
        return false;
    });
    return res;
}
app.listen(8080,'0.0.0.0', () => {
    console.log("Servidor APP AlertaUSAC en la direccion 0.0.0.0");
});