/*
Серверна частина nebula
*/
var http = require("http");
var pg = require("pg");

http.createServer(function(request, response) 
	{
	response.writeHead(200, {"Content-Type": "text/html"});
	response.write("<title>Світ, якого не було...</title>");
	response.write("<p>Lorem ipsum dolor sit amet...</p>");
	var client = new pg.Client('postgres://postgres@localhost/nebula');
	//connect to db:	
	client.on('drain', client.end.bind(client)); //disconnect client when all queries are finished
	//show users....
	client.connect(function (err) 
		{
		if (err){
			console.log('err on connect!!!');
			response.write('<br><hr>err on connect!!!');
			throw err;
			}
			// disconnect the client
		client.query('select * from messages',[],//'SELECT $1::text as name', ['brianc'], 
		function (err, result) 
			{
			if (err){
				console.log('err on query!!!');
				response.write('<br><hr>err on query!!!');
				response.end();
				throw err;
				}
			// just print the result to the console
			s='result='+JSON.stringify(result.rows);//[0]);
			console.log(s); // outputs: { name: 'brianc' }
			response.write(s);
			client.end(function (err) 
				{
				console.log('client.end');
				if (err){
					console.log('err on end!!!');
					response.end();
					throw err;
					}
				response.end();
				});
			});
		});
	//show groups...
	//show messages...
	//response.end();
	}).listen(8888);
//========= show some json data ===============	
	/*var cache = [];
	response.write(JSON.stringify([request], function(key, value) {
	if (typeof value === 'object' && value !== null) {
	if (cache.indexOf(value) !== -1) {
	    // Circular reference found, discard key
	    return;
	}
	// Store value in our collection
	cache.push(value);
	}
	return value;
	}).replace( /,/g , ",\n"));*/