#!/bin/bash
##  Create a very generic CA and a client certificate for use with Squid Proxy on Azure.

# 1. Create a Private CA
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt -subj "/CN=MySquidPrivateCA"

# 2. Create the Squid Server Certificate (Replace with your Azure VM's Public IP or DNS name)
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/CN=192.168.##.###"
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 825 -sha256

# 3. Create a Client Certificate for a User/Device
openssl genrsa -out client1.key 2048
openssl req -new -key client1.key -out client1.csr -subj "/CN=laptop-user-1"
openssl x509 -req -in client1.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client1.crt -days 825 -sha256

# 4. Bundle the Client Certificate into a .p12 file for easy installation on Windows/macOS/iOS
openssl pkcs12 -export -out client1.p12 -inkey client1.key -in client1.crt -certfile ca.crt
