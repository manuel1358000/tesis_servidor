var {Client}=require('pg');
/*var config={
    host     : '34.67.241.151',
	user     : 'postgres',
	password : 'postgres',
    database : 'tesis',
    port:5434
};*/
var config={
    host     : '127.0.0.1',
	user     : 'manuel',
	password : 'manuel',
    database : 'tesis',
    port:5432
};

const client=new Client(config);

module.exports.client=client;
