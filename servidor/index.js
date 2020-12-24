const express = require("express");
const bodyParser = require('body-parser');
var request=require('request');
const fileUpload = require('express-fileupload');
var generador_jwt=require('./src/jwt/jwt.js');
var conexionbd=require('./src/conexionbd/conexionbd.js');
const app = express();
app.use(express.static('src')); 
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
conexionbd.client.connect();
app.use(express.static('uploads'));
app.use(fileUpload({
    createParentPath: true
}));

app.post('/upload-avatar', async (req, res) => {
    try {
        if(!req.files) {
            res.send({
                status: false,
                message: 'No file uploaded'
            });
        } else {
            //Use the name of the input field (i.e. "avatar") to retrieve the uploaded file
            let avatar = req.files.avatar;         
            //Use the mv() method to place the file in upload directory (i.e. "uploads")
            avatar.mv('./uploads/' + avatar.name);
            //send response
            res.send({
                codigo: 200,
                message: 'Archivo ha sido subido',
                data: {
                    name: avatar.name,
                }
            });
        }
    } catch (err) {
        res.status(500).send(err);
    }
});
app.post('/post/iniciar_sesion',function(req,res){
    console.log(req.body);
    inicioSesion(req.body.CUI,req.body.PASSWORD).then((respuesta)=>{
        res.json(respuesta);
    });
});
app.post('/post/recuperar_contra',function(req,res){
    recuperarContra(req.body.CUI).then((respuesta)=>{
        res.json(respuesta);
    });
});


app.post('/post/imagenAU',function(req,res){
    try{
        if(!req.files){
            res.json({
                "codigo": 501,
                "mensaje": "Necesita agregar una fotografia"
            });
        }
        console.log(req.files);
        var UID =Math.floor(Math.random() * 999999);
        req.files.AVATAR.mv('./uploads/' +UID+'_'+req.files.AVATAR.name.replace(/ /g, "_"));
        res.json({"codigo":200,"mensaje":"correcto","url":UID+'_'+req.files.AVATAR.name.replace(/ /g, "_")});
    }catch(err){
        console.log(err);
        res.json({"codigo":500,"mensaje":"Ocurrio un error, al crear la fotografia "});
    }
});
app.post('/post/usuarioAU',function(req,res){
    try{
        registrarUsuarios(req.body.CUI,req.body.NOMBRE,req.body.PASSWORD,req.body.TIPO,req.body.ESTADO,req.body.IMAGEN).then((respuesta)=>{
                res.json(respuesta);
        });
    }catch(err){
        res.json({"codigo":500,"mensaje":"Ocurrio un error, al crear el usuario "});
    }
});
app.get('/get/usuarioAU',function(req,res){
    buscarUsuario(req.query.CUI).then((respuesta)=>{
        res.json(respuesta);
    });
}); 

app.get('/get/estadisticasAU',function(req,res){
    estadisticaPublicacion().then((respuesta)=>{
        res.json(respuesta);
    });
});

app.get('/verificar',function(req,res){
    console.log(req.body);
    res.json({"mensaje":"si esta arriba"});
});

app.put('/put/usuarioAU',function(req,res){
    //actualizacion de un usuario
    actualizarUsuarios(req.body.CUI,req.body.NOMBRE,req.body.PASSWORD,req.body.IMAGEN).then((respuesta)=>{
        res.json(respuesta);
    });
});
app.delete('/delete/usuarioAU',function(req,res){
    eliminarUsuario(req.body.CUI).then((respuesta)=>{
        res.json(respuesta);
    });
});

app.post('/post/publicacionAU',function(req,res){
    generador_jwt.verificarToken(req.body.TOKEN).then(()=>{
        registrarPublicacion(req.body.TIPO,req.body.NOMBRE,req.body.DESCRIPCION,req.body.POSICIONX,req.body.POSICIONY,req.body.ESTADO,req.body.CUI,req.body.SUBTIPO,req.body.FECHAHORA).then((respuesta)=>{
            res.json(respuesta);
        });
    }).catch((e)=>{
        console.log(resptoken);
        res.json({"codigo":505,"mensaje":"Token Expirado"});
    });   
});


app.get('/get/publicacionGAU',function(req,res){
    //si tiene algun parametro va a buscar un usuario en especifico
    //si no lo tiene regresa a todos los usuarios
    listado_publicaciones_generales(req.query.PAGINACION*10).then((respuesta)=>{
        res.json({"codigo":"200","mensaje":"Publicaciones Generales","data":respuesta});
    });
}); 

app.get('/get/publicacionUAU',function(req,res){
    //si tiene algun parametro va a buscar un usuario en especifico
    //si no lo tiene regresa a todos los usuarios
    if(req.query.CUI==null) res.json({"codigo":501,"mensaje":"No existe el usuario que intenta acceder"});
    listado_publicaciones_usuario(req.query.CUI,req.query.PAGINACION*10).then((respuesta)=>{
        if(respuesta==0){
		res.json({"codigo":"501","mensaje":"Ya no hay publicaciones"});
	}
	res.json({"codigo":"200","mensaje":"Publicaciones Usuario","CUI":req.query.CUI,"data":respuesta});
    });
}); 
app.put('/put/publicacionAU',function(req,res){
    //actualizacion de unq publicacion
    console.log('llego aqui '+req.body);
    actualizarPublicacion(req.body.NOMBRE,req.body.DESCRIPCION,req.body.FECHAHORA,req.body.CODPUBLICACION,req.body.SUBTIPO).then((respuesta)=>{
        res.json(respuesta);
    });
});
app.delete('/delete/publicacionAU',function(req,res){
    eliminar_publicacion(req.query.COD_PUBLICACION).then((respuesta)=>{
        res.json(respuesta);
    });
});

async function actualizarPublicacion(nombre,descripcion,fechahora,cod_publicacion,subtipo){
    var query="update publicacion set nombre='"+nombre+"',descripcion='"+descripcion+"',fechahora='"+fechahora+"', subtipo="+subtipo+"  where cod_publicacion="+cod_publicacion;
    console.log(query);
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        return {"codigo":200 ,"mensaje":"Los datos se actualizaron de manera correcta"};
    }).catch(e=>{
        return {"codigo":501,"mensaje":"Error al momento de actualizar el usuario, intente nuevamente"};            
     });
            
    return respuesta;
}

async function estadisticaPublicacion(){
    var query="select (select count(*) as eventos from publicacion pu where tipo = 2),"+
    "(select count(*) as botonpanico from publicacion pu where subtipo = 15), count(*) as alertas "+
    "from publicacion publi "+
    "where publi.tipo = 1 ";
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        if(res.rowCount!=1) return {"codigo":201,"mensaje":"No hay estadisticas"};
        return {"codigo":200,"mensaje":"Estadisticas eventos y alertas","data":res.rows};
    }).catch(e=>{
        return {"codigo":501,"mensaje":"Error al mostrar estadisticas"};
    });    
    return respuesta;
}

async function recuperarContra(cui){
    var query="select password from usuario where cui="+cui;
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        if(res.rowCount!=1) return {"codigo":201,"mensaje":"El CUI ingresado no esta registrado, intente nuevamente"};
        return {"codigo":200,"mensaje":"Recuperacion de contraseña exitosa, la contraseña para el cui "+cui+' es: '+res.rows[0].password};

    }).catch(e=>{
        return {"codigo":501,"mensaje":"Error al momento de buscar el usuario, intente nuevamente"};
    });    
    return respuesta;
}

async function eliminar_publicacion(cod_publicacion){
    var query="delete from asignacion where cod_publicacion="+cod_publicacion+"; delete from publicacion where cod_publicacion="+cod_publicacion+";";
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        return {"codigo":200,"mensaje":"Se elimino la publicacion de manera correcta"}
    }).catch(e=>{
        console.log(e);
        return {"codigo":501,"mensaje":"Error al momento de eliminar la publicacion, intente nuevamente"};
    });    
    return respuesta;
}
async function listado_publicaciones_generales(paginacion){
    var query="SELECT usu.cui,usu.nombre,publi.cod_publicacion,publi.tipo,publi.nombre,publi.descripcion,publi.posicion_x,publi.posicion_y,publi.fechahora,publi.subtipo,publi.fechahora "+
    "FROM usuario usu "+
    "INNER JOIN asignacion asi "+ 
    "ON usu.cod_usuario = asi.cod_usuario "+
    "INNER JOIN publicacion publi "+
    "ON asi.cod_publicacion = publi.cod_publicacion ";
    query+=" ORDER BY publi.fechahora DESC ";
    if(paginacion>=0){
        query+="LIMIT 10 OFFSET "+paginacion;
    }    
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        if(res.rowCount==0) return [];
        return res.rows;
    }).catch(e=>{
        console.log(e);
        return {"codigo":501,"mensaje":"Error al momento de buscar las publicaciones generales, intente nuevamente"};
    });    
    return respuesta;
}

async function listado_publicaciones_usuario(cui,paginacion){
    var query="SELECT usu.cui,usu.nombre,publi.cod_publicacion, publi.tipo,publi.nombre,publi.descripcion,publi.posicion_x,publi.posicion_y,publi.fechahora,publi.subtipo "+
    "FROM usuario usu "+
    "INNER JOIN asignacion asi "+ 
    "ON usu.cod_usuario = asi.cod_usuario "+
    "INNER JOIN publicacion publi "+
    "ON asi.cod_publicacion = publi.cod_publicacion "+
    "WHERE usu.cui="+cui+" "+
    " ORDER BY publi.fechahora DESC "+
    "LIMIT 10 OFFSET "+paginacion;
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        if(res.rowCount==0) return 0;
        return res.rows;
    }).catch(e=>{
        console.log(e);
        return {"codigo":501,"mensaje":"Error al momento de buscar las publicaciones del usuario, intente nuevamente"};
    });    
    return respuesta;
}

async function buscarUsuario(cui){
    var query="select cui,password,nombre,imagen from usuario where cui="+cui;
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        if(res.rowCount!=1) return {"codigo":201,"mensaje":"Por Favor ingrese un CUI valido"};
        return res.rows[0];
    }).catch(e=>{
        return {"codigo":501,"mensaje":"Error al momento de buscar el usuario, intente nuevamente"};
    });    
    return respuesta;
}


async function eliminarUsuario(cui){
    var query="delete from usuario where cui="+cui;
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        if(res.rowCount==1) return {"codigo":200,"mensaje":"Usuario eliminado con exito"};
        return {"codigo":200,"mensaje":"No existe un usuario con el CUI que quiere eliminar"};
    }).catch(e=>{
        console.log(e);
        return {"codigo":501,"mensaje":"Error al momento de eliminar al usuario, intente nuevamente"};
    });    
    return respuesta;
}
async function registrarUsuarios(cui,nombre,password,tipo,estado,imagen){
    var query="insert into usuario(cui,nombre,password,tipo,estado,imagen)values("+cui+",'"+nombre+"','"+password+"',"+tipo+","+estado+",'"+imagen+"')";
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        return {"codigo":200 ,"mensaje":"Usuario Creado con Exito"};
    }).catch(e=>{
        if (e.code==23505) return {"codigo":201,"mensaje":"Ya existe un usuario registrado el numero de CUI ingresado"};
            return {"codigo":501,"mensaje":"Error al momento de registrar al usuario, intente nuevamente"};
        });    
    return respuesta;
}

async function actualizarUsuarios(cui,nombre,password,imagen){
    var query="update usuario set nombre='"+nombre+"',password='"+password+"', imagen='"+imagen+"'  where cui="+cui;
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        return {"codigo":200 ,"mensaje":"Los datos se actualizaron de manera correcta"};
    }).catch(e=>{
        return {"codigo":501,"mensaje":"Error al momento de actualizar el usuario, intente nuevamente"};            
     });
            
    return respuesta;
}

async function registrarPublicacion(tipo, nombre, descripcion, posicionX, posicionY, estado,cui,subtipo,fechahora){
    if(tipo==''||nombre==''||descripcion==''||posicionX==''||posicionY==''||estado==''||cui==''||subtipo=='')return {"codigo":402,"mensaje":"Datos incompletos para realizar la publicacion, intente nuevamente"};
    var query="select CREAR_PUBLICACION("+tipo+",'"+nombre+"','"+descripcion+"',"+posicionX+","+posicionY+","+estado+","+cui+","+subtipo+",'"+fechahora+"');";
    console.log(query);
    const respuesta=await conexionbd.client.query(query)
    .then(async res=>{
        return {"codigo":200 ,"mensaje":"Publicacion Creada con Exito"};
    }).catch(e=>{
        console.log(e.toString());
        return {"codigo":501,"mensaje":"Error al momento de registrar la publicacion, intente nuevamente"};        
    }); 
    return respuesta;
}



async function inicioSesion(cui,password){
    if(cui==''&&password=='')return {"codigo":402,"mensaje":"Datos incompletos al iniciar sesion, intente nuevamente"};
    var query="select nombre,tipo from usuario where cui="+cui+" and password='"+password+"'";
    const respuesta=await conexionbd.client.query(query)
    .then(res=>{
        if(res.rowCount!=1) return {"codigo":201,"mensaje":"Por Favor ingrese un CUI/PASSWORD valido"};
        console.log(res.rows[0]);
        var payload={
            auth:"true",
            tipo:res.rows[0].tipo,
            
        };
        return generarToken(payload).then(token=>{
            return {"codigo":200,"mensaje":"Inicio de Sesion Exitoso","tipo":res.rows[0].tipo,"nombre":res.rows[0].nombre,"token":token};
        });
    }).catch(e=>{
        console.log(e);
        return {"codigo":501,"mensaje":"Error al momento de iniciar sesion, intente nuevamente"};
    })
    return respuesta;
}

app.post('/verificartoken',function(req,res){
    generador_jwt.verificarToken(req.body.token)
    .then(function(respuesta){
        console.log(respuesta);
        res.send(respuesta);
    });
});

async function generarToken(payload){
    var token=await generador_jwt.jwt.sign(payload,generador_jwt.privateKEY,generador_jwt.signOptions);
    return token;
}

/*app.listen(process.env.NODE_ESB_PORT,'0.0.0.0', () => {
    console.log("Servidor APP AlertaUSAC en la direccion 0.0.0.0");
});*/
app.listen(3000,'0.0.0.0', () => {
    console.log("Servidor APP AlertaUSAC en la direccion 0.0.0.0");
});
