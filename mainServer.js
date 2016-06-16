/*
#	This code comes with NO LICENSE and NO WARRANTY
#
#	The following code implements a simple nodejs script that
#	serve data collected from other servers through the
#   nnode.js module.
#
#	Usage: npm start
#
#	AUTHOR: Andrea Galloni andreagalloni92@gmail.com
*/
var thePort = process.env.npm_package_config_port;

var http = require("http");
var url = require('url');
var util = require('util');
var exec = require('child_process').exec;
var execSync = require('child_process').execSync;

var niface1 = "wlan1";
var niface2 = "wlan0";

var server = http.createServer(function(request, response) {

    var path = url.parse(request.url).pathname;

    var body = "";
    request.on('data', function (chunk) {
      body += chunk;
    });

  request.on('end', function () {
      console.log('body: ' + body);
      var essid = JSON.parse(body).essid;

      function connectMe(){
        exec('sudo iwconfig '+niface1+" essid "+essid,      // command line argument directly in string
            function (error, stdout, stderr) {            // one easy function to capture data/errors
              console.log('stdout: ' + stdout);
              console.log('stderr: ' + stderr);
              if (error !== null) {
                console.log('exec error: ' + error);
              }
              console.log("---------------Connected");
              response.write("Connected To: "+essid);
              response.end();
            });
      }

      function lanup(){
        console.log("---------------lanup");
        exec('sudo ',["ifconfig",niface1,"up"],connectMe);
      }

      function landown(){
        console.log("---------------landown");
        exec('sudo ',["ifconfig",niface1,"down"],lanup);
      }

      switch (path) {
          case '/Connect':
                response.writeHead(200, {
                    'Content-Type': 'text'
                });

                execSync("ifconfig "+niface1+" down");
                console.log("DOWN");
                execSync("sleep 2");
                execSync("ifconfig "+niface1+" up");
                console.log("UP");
                execSync("sleep 2");
                execSync("iwconfig "+niface1+" essid "+essid);
                console.log('CONN');
                execSync("sleep 2");
                execSync("dhclient "+niface1);
                response.write("Connected To: "+essid);
                response.end();

              break;
          case '/Dump':
                response.writeHead(200, {
                    'Content-Type': 'text'
                });
                exec('bash SENTINOWL/dump_scripts/start.sh');
                response.write("Dumping..");
                response.end();

              break;
          case '/Delete':
                response.writeHead(200, {
                    'Content-Type': 'text'
                });
                execSync("python SENTINOWL/delete.py");
                response.write("OK");
                response.end();
              break;
          case '/Notify':
                response.writeHead(200, {
                    'Content-Type': 'text'
                });
                response.write("OK");
                response.end();
              break;
          case '/Hack':
                response.writeHead(200, {
                    'Content-Type': 'text'
                });
                exec('perl SENTINOWL/skyjack/skyjack.pl '+'MAC > log.txt');
                response.write("OK");
                response.end();

              break;
          default:
                response.writeHead(200, {
                    'Content-Type': 'text'
                });
                response.write("404 resource not available");
                response.end();
              break;
      }
  });
});
server.listen(thePort);

//process.on('uncaughtException', function (err) {
//  console.log('Caught exception: ${err}\n');
//});
