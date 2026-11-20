#!/bin/bash
set -e

DOMAIN="emergencyservicessoftware.net"
CLIENT_NAME="test-client-01"
CLIENT_P12_PASS="ChangeMe123!"
CERT_DIR="./certs"
mkdir -p "$CERT_DIR"

echo "1. Generating Root CA..."
openssl genrsa -out "$CERT_DIR/rootCA.key" 4096
openssl req -x509 -new -nodes -key "$CERT_DIR/rootCA.key" -sha256 -days 3650 \
  -subj "/C=US/ST=SC/O=Emergency Services Software/CN=ESS Internal Root CA" \
  -out "$CERT_DIR/rootCA.crt"

echo "2. Generating Server Key and CSR..."
openssl genrsa -out "$CERT_DIR/server.key" 2048
openssl req -new -key "$CERT_DIR/server.key" \
  -subj "/C=US/ST=SC/O=Emergency Services Software/CN=proxy.$DOMAIN" \
  -out "$CERT_DIR/server.csr"

echo "3. Creating Server SAN configuration..."
cat > "$CERT_DIR/server_san.ext" << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = $DOMAIN
DNS.2 = *.$DOMAIN
# Uncomment and add your server's IP if connecting directly by IP:
# IP.1 = 192.168.1.100
EOF

echo "4. Signing Server Certificate..."
openssl x509 -req -in "$CERT_DIR/server.csr" -CA "$CERT_DIR/rootCA.crt" \
  -CAkey "$CERT_DIR/rootCA.key" -CAcreateserial -out "$CERT_DIR/server.crt" \
  -days 825 -sha256 -extfile "$CERT_DIR/server_san.ext"

echo "5. Generating Client Key and CSR..."
openssl genrsa -out "$CERT_DIR/$CLIENT_NAME.key" 2048
openssl req -new -key "$CERT_DIR/$CLIENT_NAME.key" \
  -subj "/C=US/ST=SC/O=Emergency Services Software/CN=$CLIENT_NAME" \
  -out "$CERT_DIR/$CLIENT_NAME.csr"

echo "6. Signing Client Certificate and creating .p12 bundle..."
cat > "$CERT_DIR/client_ext.ext" << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth
EOF

openssl x509 -req -in "$CERT_DIR/$CLIENT_NAME.csr" -CA "$CERT_DIR/rootCA.crt" \
  -CAkey "$CERT_DIR/rootCA.key" -CAcreateserial -out "$CERT_DIR/$CLIENT_NAME.crt" \
  -days 825 -sha256 -extfile "$CERT_DIR/client_ext.ext"

openssl pkcs12 -export -out "$CERT_DIR/$CLIENT_NAME.p12" \
  -inkey "$CERT_DIR/$CLIENT_NAME.key" -in "$CERT_DIR/$CLIENT_NAME.crt" \
  -certfile "$CERT_DIR/rootCA.crt" -passout pass:"$CLIENT_P12_PASS"

# Clean up temporary files
rm "$CERT_DIR"/*.csr "$CERT_DIR"/*.ext

echo "Done! Certificates are located in $CERT_DIR/"
