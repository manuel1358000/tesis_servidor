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
app.post('/post/usuarioAU',function(req,res){
    registrarUsuarios(req.body.CUI,req.body.NOMBRE,req.body.PASSWORD,req.body.TIPO,req.body.ESTADO).then((respuesta)=>{
            res.json(respuesta);
    });
});

app.post('/post/iniciar_sesion',function(req,res){
    inicioSesion(req.body.CUI,req.body.PASSWORD).then((respuesta)=>{
        res.json(respuesta);
    });
});

app.delete('/delete/usuarioAU',function(req,res){
    eliminarUsuario(req.body.CUI).then((respuesta)=>{
        res.json(respuesta);
    });
});

async function eliminarUsuario(cui){
    var query="delete from usuario where cui="+cui;
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        if(res.rowCount==1) return {"codigo":200,"mensaje":"Usuario eliminado con exito"};
        return {"codigo":200,"mensaje":"No existe un usuario con el CUI que quiere eliminar"};
    }).catch(e=>{
        return {"codigo":501,"mensaje":"Error al momento de eliminar al usuario, intente nuevamente"};
    });    
    return respuesta;
}
async function registrarUsuarios(cui,nombre,password,tipo,estado){
    var query="insert into usuario(cui,nombre,password,tipo,estado)values("+cui+",'"+nombre+"','"+password+"',"+tipo+","+estado+")";
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        return {"codigo":200 ,"mensaje":"Usuario Creado con Exito"};
    }).catch(e=>{
        if (e.code==23505) return {"codigo":200,"mensaje":"Ya existe un usuario registrado el numero de CUI ingresado"};
            return {"codigo":501,"mensaje":"Error al momento de registrar al usuario, intente nuevamente"};
        });    
    return respuesta;
}

async function inicioSesion(cui,password){
    if(cui==''&&password=='')return {"codigo":402,"mensaje":"Datos incompletos al iniciar sesion, intente nuevamente"};
    var query="select cod_usuario,nombre,tipo,estado from usuario where cui="+cui+" and password='"+password+"'";
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        if(res.rowCount==1) return {"codigo":200,"mensaje":"Inicio de Sesion Exitoso","data":res.rows[0]};
        return {"codigo":200,"mensaje":"Por Favor ingrese un CUI/PASSWORD valido"};
    }).catch(e=>{
        return {"codigo":501,"mensaje":"Error al momento de iniciar sesion, intente nuevamente"};
    })
    return respuesta;
}

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

app.listen(8080,'0.0.0.0', () => {
    console.log("Servidor APP AlertaUSAC en la direccion 0.0.0.0");
});