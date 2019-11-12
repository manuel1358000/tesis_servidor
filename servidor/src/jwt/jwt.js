var jwt=require('jsonwebtoken');
var fs=require('fs');
var privateKEY=fs.readFileSync('./src/private.key','utf8');
var signOptions={
    algorithm:"HS256",
    noTimestamp:true,
    expiresIn:'24h',
};
function generarToken(payload){
    var token=jwt.sign(payload,privateKEY,signOptions);
    return token;
}
function verificarToken(token){
    const promise=new Promise(function(resolve,reject){
        var legit=jwt.verify(token,privateKEY,function(err,decoded){
            if(err){
                resolve(decoded);
            }else{
                resolve(decoded);
            }
        });
    });
    return promise;
}
module.exports.verificarToken=verificarToken;
module.exports.generarToken=generarToken;
module.exports.privateKEY=privateKEY;
module.exports.signOptions=signOptions;
module.exports.jwt=jwt;