# Directorio donde se guardarán los certificados y claves del servidor y CA
SERVER_CERT_DIR="/home/cvp/Entrega-2-iot/mosquitto/server_certs"

# Directorio donde se guardarán los certificados y claves de los clientes
CLIENT_CERT_DIR="/home/cvp/Entrega-2-iot/certs_clientes"

# Nombre del cliente base
CLIENT_BASE_NAME="ClaudiaPortatil"
SERVER_BASE_NAME="Entrega-2"

# Crear los directorios si no existen
mkdir -p "$CERT_DIR"
mkdir -p "$CLIENT_CERT_DIR"
# ---------------------------Configurción con SAN ------------------------
# Obtener la dirección IP del contenedor Mosquitto
# Obtener la dirección IP del contenedor Mosquitto
# CONTAINER_NAME="mosquitto"  # Nombre del contenedor Mosquitto
# IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_NAME)# SAN="subjectAltName=IP:$IP"
# # Generar un certificado de autoridad (CA)
# openssl req -new -x509 -days 3650 -keyout "$CERT_DIR/ca.key" -out "$CERT_DIR/ca.crt" -subj "/CN=MyCA/OU=MyOrganization/C=US"

# # Generar una clave privada y un certificado autofirmado para el servidor
# openssl req -new -nodes -newkey rsa:2048 -keyout "$CERT_DIR/server.key" -out "$CERT_DIR/server.csr" -subj "/CN=$IP/OU=MyOrganization/C=US"
# openssl x509 -req -days 365 -in "$CERT_DIR/server.csr" -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" -CAcreateserial -out "$CERT_DIR/server.crt" -extfile <(echo $SAN)

# # Limpiar archivos temporales
# rm -f "$CERT_DIR/server.csr" "$CERT_DIR/ca.srl"
# ---------------------------Configurción con SAN ------------------------


# Generar un certificado de autoridad (CA)
openssl req -new -x509 -days 3650 -extensions v3_ca -keyout "$SERVER_CERT_DIR/ca.key" -out "$SERVER_CERT_DIR/ca.crt" -subj "/CN=MyCA/OU=MyOrganization/C=US"

# Generar una clave privada y un certificado autofirmado para el servidor
openssl req -new -nodes -newkey rsa:2048 -keyout "$SERVER_CERT_DIR/server.key" -out "$SERVER_CERT_DIR/server.csr" -subj "/CN=$SERVER_BASE_NAME"
openssl x509 -req -days 365 -in "$SERVER_CERT_DIR/server.csr" -CA "$SERVER_CERT_DIR/ca.crt" -CAkey "$SERVER_CERT_DIR/ca.key" -CAcreateserial -out "$SERVER_CERT_DIR/server.crt"

# Limpiar archivos temporales
rm "$SERVER_CERT_DIR/server.csr" "$SERVER_CERT_DIR/ca.srl"

echo "Certificados y claves del servidor generados con éxito en $SERVER_CERT_DIR"

# Generar claves privadas y certificados autofirmados para cada cliente
i=1
while [ $i -le 4 ]; do
    CLIENT_NAME="${CLIENT_BASE_NAME}${i}"
    openssl req -new -nodes -newkey rsa:2048 -keyout "$CLIENT_CERT_DIR/$CLIENT_NAME.key" -out "$CLIENT_CERT_DIR/$CLIENT_NAME.csr" -subj "/CN=$CLIENT_NAME"
    openssl x509 -req -days 365 -in "$CLIENT_CERT_DIR/$CLIENT_NAME.csr" -CA "$SERVER_CERT_DIR/ca.crt" -CAkey "$SERVER_CERT_DIR/ca.key" -CAcreateserial -out "$CLIENT_CERT_DIR/$CLIENT_NAME.crt"
    # Limpiar archivos temporales
    rm "$CLIENT_CERT_DIR/$CLIENT_NAME.csr"
    i=$((i + 1))
done

# Copiar los certificados de los clientes al directorio del servidor
cp "$CLIENT_CERT_DIR"/*.crt "$SERVER_CERT_DIR"
cp "$CLIENT_CERT_DIR"/*.key "$SERVER_CERT_DIR"

# Establecer los permisos adecuados para el servidor
chmod 600 "$SERVER_CERT_DIR"/*.key

echo "Certificados y claves generados con éxito en $SERVER_CERT_DIR y $CLIENT_CERT_DIR"
echo "$IP"
