import ssl
import random
from paho.mqtt import client as mqtt_client

# Configuración del cliente MQTT
broker_address = "Entrega-2"
port = 8883

MQTT_TOPIC = "reto2"

client_id = f'python-mqtt-{random.randint(0, 1000)}'
username = "admin"  # Opcional, dependiendo de la configuración del broker
password = "admin"  # Opcional, dependiendo de la configuración del broker
cert_path = "/home/cvp/Entrega-2-iot/certs_clientes/ClaudiaPortatil2.crt"
key_path = "/home/cvp/Entrega-2-iot/certs_clientes/ClaudiaPortatil2.key"
ca_cert = "/home/cvp/Entrega-2-iot/mosquitto/server_certs/ca.crt"

# Función de conexión al broker MQTT
def on_connect(client, userdata, flags, rc, properties):
    if rc == 0:
        print("Conectado al broker MQTT.")
        # Suscribirse al tema una vez conectado
        client.subscribe(MQTT_TOPIC)
    else:
        print("Error de conexión. Código de retorno:", rc)

# Manejador de eventos de recepción de mensaje
def on_message(client, userdata, message):
    print("Mensaje recibido en el tema:", message.topic)
    print("Contenido del mensaje:", message.payload.decode())

# Configurar el cliente MQTT con TLS/SSL
client = mqtt_client.Client(mqtt_client.CallbackAPIVersion.VERSION1, client_id)
client.tls_set(ca_certs=ca_cert, certfile=cert_path, keyfile=key_path, cert_reqs=ssl.CERT_REQUIRED, tls_version=ssl.PROTOCOL_TLS)
client.tls_insecure_set(True)

# Configurar el manejo de eventos de conexión y mensaje
client.on_connect = on_connect
client.on_message = on_message

# Autenticación, si es necesaria
if username is not None and password is not None:
    client.username_pw_set(username, password)

# Conectar al broker MQTT
client.connect(broker_address, port)

# Iniciar el bucle de red para manejar la comunicación con el broker
client.loop_forever()
