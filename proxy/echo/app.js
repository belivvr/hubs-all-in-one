const http = require('http');

const server = http.createServer((req, res) => {
    console.log(`Request received: ${req.method} ${req.url}`);

    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('OK');
});

const port = 9000;
const hostname = '0.0.0.0';

server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
});
