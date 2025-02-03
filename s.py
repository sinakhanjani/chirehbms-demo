from time import sleep
from socket import socket,AF_INET,SOCK_STREAM
import json
from time import sleep
sock = socket(AF_INET,SOCK_STREAM)
Target = ('95.216.21.234',3030)
d1 = bytes("test2|".encode())
d2 = bytes("CheckActivity".encode())
d3 = bytes("|1".encode())
d4 = bytes("#end".encode())
sock.connect(Target)
sock.send(d1)
sock.send(d2)
sock.send(d3)
sock.send(d4)
dd = sock.recv(1024)
dd = dd.decode()
print(dd)
print("\nSplitted Data Here !\n")
dd = sock.recv(1024)
dd = dd.decode()
print(dd)
sock.close()
