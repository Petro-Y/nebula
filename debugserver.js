//debug server
var fs = require('fs');
var http = require('http');
var url = require('url');

http.createServer(function(request, response) 
	{
	var pathname = url.parse(request.url).pathname;
	response.writeHead(200, {"Content-Type": "text/html"});
	response.write('<title>debug server:'+pathname+'</title>');
	if(pathname=='/exit')
		{
		response.write('Exiting... <a href="/?">(go top)</a><br>');
		response.end();
		process.exit(0);
		}
	else if(pathname=='/exit2')
		{
		response.write('Exiting... <a href="/?">(go top)</a><br>');
		response.end();
		process.exit(2);
		}
	else if(pathname=='/log')
		{
		response.write('<h2>server log <a href="/?">(go top)</a></h2>');
		var log = fs.readFileSync('server.log', 'utf8');
		//show server.log:
		response.write('<pre>'+log+'</pre>');
		response.end();
		}
	else	{
		//show index:
		response.write('<a href=log?>show log</a><br>');
		response.write('<a href=exit?>exit debug server</a><br>');
		response.write('<a href=exit2?>exit debug server (no update)</a><br>');
		response.end();
		}
	}).listen(8888);