var {Client}=require('pg');
var config={
    host     : '127.0.0.1',
	user     : 'manuel',
	password : 'manuel',
    database : 'tesis',
    port:5432
};

const client=new Client(config);

module.exports.client=client;