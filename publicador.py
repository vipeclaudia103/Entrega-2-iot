# import ssl
# import paho.mqtt.publish as publish

# # Configuración del cliente MQTT
# broker_address = "localhost"
# port = 8883
# cert_path = "/usr/src/app/certs/client.crt"
# key_path = "/usr/src/app/certs/client.key"
# ca_cert = "/usr/src/app/certs/ca.crt"
# topic = "topic/test"

# # Configurar TLS/SSL
# tls = {
#     'ca_certs': ca_cert,
#     'certfile': cert_path,
#     'keyfile': key_path,
#     'tls_version': ssl.PROTOCOL_TLS
# }

# # Mensaje a publicar
# message = "Hello, World!"

# # Publicar el mensaje
# publish.single(topic, message, hostname=broker_address, port=port, tls=tls)
# print("Mensaje publicado exitosamente!")

#simulador del dispositivo 1 para publicar mensajes MQTT
from paho.mqtt import client as mqtt_client
import random
import time

# # nombre del host
# broker = "10.3.20.3"
# # puerto
# port = 1883


broker_hostname = "localhost"
port = 1883 

def on_connect(client, userdata, flags, return_code):
    if return_code == 0:
        print("connected")
    else:
        print("could not connect, return code:", return_code)

client_id = f'python-mqtt-{random.randint(0, 1000)}'
client = mqtt_client.Client(mqtt_client.CallbackAPIVersion.VERSION1, client_id)
# client.username_pw_set(username="user_name", password="password") # uncomment if you use password auth
client.on_connect = on_connect

client.connect(broker_hostname, port)
client.loop_start()

topic = "Test"
msg_count = 0

try:
    while msg_count < 10:
        time.sleep(1)
        msg_count += 1
        result = client.publish(topic, msg_count)
        status = result[0]
        if status == 0:
            print("Message "+ str(msg_count) + " is published to topic " + topic)
        else:
            print("Failed to send message to topic " + topic)
            if not client.is_connected():
                print("Client not connected, exiting...")
                break
finally:
    client.disconnect()
    client.loop_stop()