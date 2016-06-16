import sys
import telnetlib

import os
from threading import Thread

#install gzip 

HOST = "192.168.1.1"
tn = telnetlib.Telnet(HOST, "23")
tn.write("install gzip\n")

tn.write("exit\n")
print tn.read_all()
