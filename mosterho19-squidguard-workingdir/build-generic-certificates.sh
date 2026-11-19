#!/bin/bash
## generic create ca certs
## BEFORE RUNNING THIS: Ensure the CN in the server cert to your Azure VM's public IP or DNS name. This is important for SSL/TLS validation.

IP_ADDR=$(hostname -I | awk '{print $1}') && 
CN_NAME="/CN=${IP_ADDR}" && 
echo "Using CN_NAME: $CN_NAME" &&
SERVER_NAME="proxy.emergencyservicessoftware.net" &&
CN_NAME_DNS="/CN=${SERVER_NAME}" &&
echo "Using CN_NAME_DNS: $CN_NAME_DNS"

##  Actual user contains the username of the user who invoked sudo, or the current user if not using sudo.
actual_user="${SUDO_USER:-$(whoami)}"
mkdir -p /home/$actual_user/proxy && sudo cp ./certificates/client1.p12 /home/$actual_user/proxy/client1.p12
sudo chown -R proxy:proxy ./certificates

# 1. Create a Private CA
openssl genrsa -out ./certificates/ca.key 4096
openssl req -x509 -new -nodes -key ./certificates/ca.key -sha256 -days 3650 -out ./certificates/ca.crt -subj "/CN=MySquidPrivateCA"

# 2. Create the Squid Server Certificate (Replace with your Azure VM's Public IP or DNS name)
openssl genrsa -out ./certificates/server.key 2048
## Change the CN in this line.
## If using a DNS name, use the following format:
##  -subj "/C=US/O=Emergency Services Software/CN=${SERVER_NAME}"
openssl req -new -key ./certificates/server.key -out ./certificates/server.csr -subj "$CN_NAME" -addext "subjectAltName=DNS:://${SERVER_NAME},IP:$IP_ADDR"
openssl x509 -req -in ./certificates/server.csr -CA ./certificates/ca.crt -CAkey ./certificates/ca.key -CAcreateserial -out ./certificates/server.crt -days 825 -sha256

# 3. Create a Client Certificate for a User/Device
openssl genrsa -out ./certificates/client1.key 2048
openssl req -new -key ./certificates/client1.key -out ./certificates/client1.csr -subj "/CN=laptop-user-1"
openssl x509 -req -in ./certificates/client1.csr -CA ./certificates/ca.crt -CAkey ./certificates/ca.key -CAcreateserial -out ./certificates/client1.crt -days 825 -sha256

# 4. Bundle the Client Certificate into a .p12 file for easy installation on Windows/macOS/iOS
openssl pkcs12 -export -out ./certificates/client1.p12 -inkey ./certificates/client1.key -in ./certificates/client1.crt -certfile ./certificates/ca.crt

