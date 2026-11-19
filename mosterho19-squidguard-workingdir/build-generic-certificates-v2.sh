#!/bin/bash
set -e

mkdir -p ./certificates

IP_ADDR=$(hostname -I | awk '{print $1}')
SERVER_NAME="proxy.emergencyservicessoftware.net"
CN_NAME_DNS="/CN=${SERVER_NAME}"

echo "Using Server DNS: $SERVER_NAME"
echo "Using Server IP:  $IP_ADDR"

# 1. Create a Private CA
openssl genrsa -out ./certificates/ca.key 4096
openssl req -x509 -new -nodes -key ./certificates/ca.key -sha256 -days 3650 \
  -out ./certificates/ca.crt \
  -subj "/C=US/O=Emergency Services Software/CN=MySquidPrivateCA"

# 2. Create the Squid Server Certificate with SAN (DNS + IP)
openssl genrsa -out ./certificates/server.key 2048
openssl req -new -key ./certificates/server.key -out ./certificates/server.csr \
  -subj "$CN_NAME_DNS" \
  -addext "subjectAltName=DNS:${SERVER_NAME},IP:${IP_ADDR}"

# -copy_extensions copy is required to transfer the SAN from the CSR to the signed cert
openssl x509 -req -in ./certificates/server.csr \
  -CA ./certificates/ca.crt -CAkey ./certificates/ca.key -CAcreateserial \
  -out ./certificates/server.crt \
  -days 825 -sha256 \
  -copy_extensions copy

# 3. Create a Client Certificate for a User/Device
openssl genrsa -out ./certificates/client1.key 2048
openssl req -new -key ./certificates/client1.key -out ./certificates/client1.csr \
  -subj "/CN=laptop-user-1"
openssl x509 -req -in ./certificates/client1.csr \
  -CA ./certificates/ca.crt -CAkey ./certificates/ca.key -CAcreateserial \
  -out ./certificates/client1.crt \
  -days 825 -sha256

# 4. Bundle the Client Certificate into a .p12 file for Windows/macOS/iOS
# -legacy ensures compatibility with Windows Server 2016/2019 and older Windows 10 builds
openssl pkcs12 -export -legacy \
  -out ./certificates/client1.p12 \
  -inkey ./certificates/client1.key \
  -in ./certificates/client1.crt \
  -certfile ./certificates/ca.crt

# 5. Set Docker-compatible permissions (UID 13 = proxy inside Ubuntu containers)
sudo chown -R 13:13 ./certificates
sudo chmod 750 ./certificates
sudo chmod 640 ./certificates/*.key
sudo chmod 644 ./certificates/*.crt

# 6. Copy client .p12 to the invoking user's home folder
actual_user="${SUDO_USER:-$(whoami)}"
mkdir -p "/home/$actual_user/proxy"
sudo cp ./certificates/client1.p12 "/home/$actual_user/proxy/client1.p12"
sudo chown -R "$actual_user:$actual_user" "/home/$actual_user/proxy"

# 7. Verify the SAN in the generated server certificate
echo "--- Verifying Server Certificate SAN ---"
openssl x509 -in ./certificates/server.crt -noout -ext subjectAltName
