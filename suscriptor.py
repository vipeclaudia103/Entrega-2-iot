# import ssl
# import paho.mqtt.client as mqtt

# # Configuración del cliente MQTT
# broker_address = "localhost"
# port = 8883
# cert_path = "/usr/src/app/certs/client.crt"
# key_path = "/usr/src/app/certs/client.key"
# ca_cert = "/usr/src/app/certs/ca.crt"
# topic = "topic/test"

# # Función de conexión al broker MQTT
# def on_connect(client, userdata, flags, rc):
#     print("Conectado al broker MQTT con resultado " + str(rc))
#     # Suscribirse al tema
#     client.subscribe(topic)

# # Función para manejar los mensajes recibidos
# def on_message(client, userdata, msg):
#     print("Mensaje recibido: " + msg.topic + " " + str(msg.payload))

# # Configurar el cliente MQTT con TLS/SSL
# client = mqtt.Client()
# client.tls_set(ca_certs=ca_cert, certfile=cert_path, keyfile=key_path, cert_reqs=ssl.CERT_REQUIRED, tls_version=ssl.PROTOCOL_TLS)
# client.on_connect = on_connect
# client.on_message = on_message

# # Conectar al broker MQTT
# client.connect(broker_address, port)

# # Iniciar el bucle de red para manejar la comunicación con el broker
# client.loop_forever()

from paho.mqtt import client as mqtt_client
import random
import time

def on_connect(client, userdata, flags, return_code):
    if return_code == 0:
        print("connected")
        client.subscribe("Test")
    else:
        print("could not connect, return code:", return_code)
        client.failed_connect = True


def on_message(client, userdata, message):
    print("Received message: ", str(message.payload.decode("utf-8")))


broker_hostname ="localhost"
port = 1883 

client_id = f'python-mqtt-{random.randint(0, 1000)}'
client = mqtt_client.Client(mqtt_client.CallbackAPIVersion.VERSION1, client_id)
# client.username_pw_set(username="user_name", password="password") # uncomment if you use password auth
client.on_connect = on_connect
client.on_message = on_message
client.failed_connect = False

client.connect(broker_hostname, port) 
client.loop_start()

# this try-finally block ensures that whenever we terminate the program earlier by hitting ctrl+c, it still gracefully exits
try:
    i = 0
    while i < 15 and client.failed_connect == False:
        time.sleep(1)
        i = i + 1
    if client.failed_connect == True:
        print('Connection failed, exiting...')

finally:
    client.disconnect()
    client.loop_stop()