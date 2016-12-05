/*
Серверна частина nebula
*/
var http = require("http");
var pg = require("pg");
var client = new pg.Client('postgres://postgres@localhost/nebula');

http.createServer(function(request, response) 
	{
	response.writeHead(200, {"Content-Type": "text/html"});
	response.write("<title>Світ, якого не було...</title>");
	response.write("<p>Lorem ipsum dolor sit amet...</p>");
	//connect to db:	
	client.on('drain', client.end.bind(client)); //disconnect client when all queries are finished
	//show users....
	//select username from users;
	client.connect(function (err) 
		{
		if (err){
			console.log('err on connect!!!');
			response.write('<br><br>err on connect!!!');
			throw err;
			}
		client.query('select username from users',[],//'SELECT $1::text as name', ['brianc'], 
		function (err, result) 
			{
			if (err){
				console.log('err on query!!!');
				response.write('<br><br>err on query!!!');
				response.end();
				throw err;
				}
			
			// just print the result to the console
			s=JSON.stringify(result.rows[0]);
			console.log(s); // outputs: { name: 'brianc' }
			response.write(s);
			// disconnect the client
			client.end(function (err) 
				{
				if (err){
					console.log('err on end!!!');
					response.end();
					throw err;
					}
				});
			response.end();
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