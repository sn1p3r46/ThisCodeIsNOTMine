import sys
import telnetlib
import subprocess

import os
from threading import Thread

#dump the proc dir

#command to get the new IP of the rapsberry pie: "ifconfig wlan0 | grep \"inet addr\" | cut -d \":\" -f 2 |  grep -E -o \"192.168.1.[0-9]"

hostIP = "192.168.1.1"
tmp = os.popen("ifconfig wlan0 | grep \"inet addr\" | cut -d \":\" -f 2 |  grep -E -o \"192.168.1.[0-9]\"").read() #get the IP
dstIP = str(tmp).rstrip('\n') #convert it into a string and remove the new line

command = "nc -w 3 " + dstIP + " 23 < proc.tar.gz \n" 

def waiting():
	os.system("nc -l -p 23 > proc.tar.gz \n") #waiting for the incoming packet

def sending():
	tn = telnetlib.Telnet(hostIP, "23")  #use the telnet and send the packet

	tn.write("tar -zcvf proc.tar.gz proc\n")
	tn.write(command)
	tn.write("exit\n")

	print tn.read_all()

thread = Thread(target = waiting)
thread.start()

thread2 = Thread(target = sending)
thread2.start()

thread.join(40)
thread2.join(40)



