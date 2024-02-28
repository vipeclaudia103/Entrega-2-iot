# Directorio donde se guardarán los certificados y claves
CERT_DIR="/home/cvp/repos/Entrega-2-iot/app/certs"

# Crear el directorio si no existe
mkdir -p "$CERT_DIR"

# Generar un certificado de autoridad (CA)
openssl req -new -x509 -days 3650 -extensions v3_ca -keyout "$CERT_DIR/ca.key" -out "$CERT_DIR/ca.crt" -subj "/CN=MyCA/OU=MyOrganization/C=US"

# Generar una clave privada y un certificado autofirmado para el servidor
openssl req -new -nodes -newkey rsa:2048 -keyout "$CERT_DIR/server.key" -out "$CERT_DIR/server.csr" -subj "/CN=localhost"
openssl x509 -req -days 365 -in "$CERT_DIR/server.csr" -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" -CAcreateserial -out "$CERT_DIR/server.crt"

# Limpiar archivos temporales
rm "$CERT_DIR/server.csr" "$CERT_DIR/ca.srl"

# Generar una clave privada y un certificado autofirmado para el cliente
openssl req -new -nodes -newkey rsa:2048 -keyout "$CERT_DIR/client.key" -out "$CERT_DIR/client.csr" -subj "/CN=Client"
openssl x509 -req -days 365 -in "$CERT_DIR/client.csr" -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" -CAcreateserial -out "$CERT_DIR/client.crt"

# Limpiar archivos temporales
rm "$CERT_DIR/client.csr" "$CERT_DIR/ca.srl"

# Establecer los permisos adecuados
chmod 600 "$CERT_DIR"/*.key

echo "Certificados y claves generados con éxito en $CERT_DIR"
