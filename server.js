/*
Серверна частина nebula
*/
var http = require('http');
var fs = require('fs');
var pg = require('pg');           //postgres
var cheerio = require('cheerio');//jQuery-like server-side library

function placeOnPage($, itemclass, data)
	{
	//$=cheerio.load(template);
	$(itemclass).addClass('blank');
	var item=$.html(itemclass);
	for (i in data)
		{
		var row=data[i];
		for (j in row)
			{
			$(itemclass+'.blank .'+j).text(row[j]||'');
			}
		$(itemclass+'.blank').addClass('done')
		                 .removeClass('blank');
		$(item).insertAfter(itemclass+'.done');
		$(itemclass+'.done').removeClass('done');
		}
	$(itemclass+'.blank').remove();
	//return $.html();
	}
	
var template = fs.readFileSync('messages.html', 'utf8');;//завантажити з messages.html
http.createServer(function(request, response) 
	{
	response.writeHead(200, {"Content-Type": "text/html"});
	$=cheerio.load(template);
	var incomplete=1;
	function finish()
		{
		incomplete--;
		if(incomplete<=0)
			{
			//завершувальні дії...
			response.write($.html());
			response.end();
			}
		}
	//response.write("<title>Світ, якого не було...</title>");
	//response.write("<p>Lorem ipsum dolor sit amet...</p>");
	var client = new pg.Client('postgres://postgres@localhost/nebula');
	//connect to db:	
	client.on('drain', client.end.bind(client)); //disconnect client when all queries are finished
	//show users....
	//show messages...
	incomplete++;
	client.connect(function (err) 
		{
		if (err){
			console.log('err on connect!!!');
			response.write('<br><hr>err on connect!!!');
			throw err;
			}
			// disconnect the client
		client.query("select username, groupname, title, content from messages natural join users natural join groups where commentto is null",[],
		//'SELECT $1::text as name', ['brianc'], 
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
			//response.write(s);
			placeOnPage($, '.message',result.rows);
			client.end(function (err) 
				{
				console.log('client.end');
				if (err){
					console.log('err on end!!!');
					response.end();
					throw err;
					}
				finish();
				//response.end();
				});
			});
		});
	//show groups...
	//response.end();
	finish();
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