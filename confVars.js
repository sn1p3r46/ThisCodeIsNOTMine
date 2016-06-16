var sensor1 = {name:"sensor1",	x:0,	y:0,	data: null};
var sensor2 = {name:"sensor2",	x:100,	y:0, 	data: null};
var sensor3 = {name:"sensor3",	x:100,	y:100, 	data: null};
var sensor4 = {name:"sensor4",	x:0, 	y:100,  data: null};
var sensor5 = {name:"sensor5",	x:50, 	y:50,   data: null};

var sensorArr = [sensor1,sensor2,sensor3,sensor4,sensor5];
//var addrArr   = ['127.0.0.1','127.0.0.1','127.0.0.1','127.0.0.1','127.0.0.1'];
var addrArr   = ['192.168.1.109','192.168.1.109','192.168.1.109','192.168.1.109','192.168.1.109'];
var portArr   = [7777,7778,7779,7780,7781];

exports.sensorArr = sensorArr;
exports.addrArr = addrArr;
exports.portArr =portArr;
