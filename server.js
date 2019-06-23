var http = require('http');
var exec = require('child_process').exec;

var book_url = process.env.BOOK_URL;


http.createServer(function (req, res) {
    res.write('success. git repo url: '+book_url);
    res.end();

    var cmd = 'cd book && git pull && gitbook install && cd ..';
    exec(cmd, function (error, stdout, stderr) {
        console.log("ok");
        console.log(stdout);
        
    });
}).listen(4001);