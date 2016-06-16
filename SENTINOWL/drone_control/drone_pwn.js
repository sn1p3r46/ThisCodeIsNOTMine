var arDrone = require('ar-drone');
var http    = require('http');

var client = arDrone.createClient();
client.disableEmergency();

client.takeoff(); //TO the exam: comment it out

client.after(2000, function() {
    this.stop()
    this.land()
  });
