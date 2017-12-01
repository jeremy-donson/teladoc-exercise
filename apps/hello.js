// load http module
var http = require('http');

// configure HTTP server
var server = http.createServer(function (request, response) {
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.end("Hello Node App");
});

// listen localhost:8081
server.listen(8081);
console.log("Node Server is at http://127.0.0.1:8081/");