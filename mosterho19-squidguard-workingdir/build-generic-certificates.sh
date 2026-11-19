#!/bin/bash
## generic create ca certs
## BEFORE RUNNING THIS: Change the CN in the server cert to your Azure VM's public IP or DNS name. This is important for SSL/TLS validation.

# 1. Create a Private CA
openssl genrsa -out ./certificates/ca.key 4096
openssl req -x509 -new -nodes -key ./certificates/ca.key -sha256 -days 3650 -out ./certificates/ca.crt -subj "/CN=MySquidPrivateCA"

# 2. Create the Squid Server Certificate (Replace with your Azure VM's Public IP or DNS name)
openssl genrsa -out ./certificates/server.key 2048
## Change the CN in this line.
## If using a DNS name, use the following format:
##  -subj "/C=US/O=Emergency Services Software/CN=proxy.emergencyservicessoftware.com"
openssl req -new -key ./certificates/server.key -out ./certificates/server.csr -subj "/CN=192.168.##.###"
openssl x509 -req -in ./certificates/server.csr -CA ./certificates/ca.crt -CAkey ./certificates/ca.key -CAcreateserial -out ./certificates/server.crt -days 825 -sha256

# 3. Create a Client Certificate for a User/Device
openssl genrsa -out ./certificates/client1.key 2048
openssl req -new -key ./certificates/client1.key -out ./certificates/client1.csr -subj "/CN=laptop-user-1"
openssl x509 -req -in ./certificates/client1.csr -CA ./certificates/ca.crt -CAkey ./certificates/ca.key -CAcreateserial -out ./certificates/client1.crt -days 825 -sha256

# 4. Bundle the Client Certificate into a .p12 file for easy installation on Windows/macOS/iOS
openssl pkcs12 -export -out ./certificates/client1.p12 -inkey ./certificates/client1.key -in ./certificates/client1.crt -certfile ./certificates/ca.crt
