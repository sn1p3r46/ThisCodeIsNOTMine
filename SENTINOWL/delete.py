import getpass
import sys
import telnetlib

HOST = "192.168.1.1" #the drone always gets the 192.168.1.1
tn = telnetlib.Telnet(HOST, "23") #use telnet

tn.write("ls\n")
tn.write("cd /data/ \n") #change the directory
tn.write("ls\n")
tn.write("rm -r video/\n") #delete the videos and images

tn.write("exit\n")
print tn.read_all()

