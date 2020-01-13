var {Client}=require('pg');
var config={
    host     : '192.168.0.17',
	user     : 'postgres',
	password : 'postgres',
    database : 'tesis',
    port:5434
};

const client=new Client(config);

module.exports.client=client;