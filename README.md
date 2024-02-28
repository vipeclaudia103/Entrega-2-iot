# Entrega-2-iot
Repositorio para la entrega de la segunda práctica en la asignatura de Desarrollo de aplicaciones IOT

comandos para actualiza y crear el contenedor:

# Detener el contenedor
docker stop entrega2

# Eliminar el contenedor
docker rm entrega2

# Reconstruir la imagen (si es necesario)
docker build -t entrega2 .

# Crear y ejecutar el contenedor actualizado
docker run --name entrega2 -d entrega2




# INSTALACIÓN MQTT MOSQUITTO

Para instalar Mosquitto MQTT en Ubuntu, puedes seguir estos pasos:

1. **Actualizar el índice de paquetes**: Es recomendable actualizar el índice de paquetes antes de instalar nuevas aplicaciones.

    ```bash
    sudo apt update
    ```

2. **Instalar Mosquitto broker y cliente MQTT**:

    ```bash
    sudo apt install mosquitto mosquitto-clients
    ```

3. **Verificar el estado de Mosquitto**: Después de la instalación, Mosquitto debería iniciarse automáticamente. Puedes verificar su estado con el siguiente comando:

    ```bash
    sudo systemctl status mosquitto
    ```

    Si el servicio está en ejecución, deberías ver un mensaje indicando que está activo.

4. **Habilitar el inicio automático de Mosquitto (opcional)**: Si deseas que Mosquitto se inicie automáticamente cada vez que se inicie el sistema, puedes habilitarlo con el siguiente comando:

    ```bash
    sudo systemctl enable mosquitto
    ```

# EJECUTAR POR TERMINAL SIN SEGURIDAD
1. Suscríbete a un tema:

    ```bash
    mosquitto_sub -h localhost -t saludo
    ```

2. Publica un mensaje en el mismo tema:

    ```bash
    mosquitto_pub -h localhost -t saludo -m "Hola estas suscrito al topic saludo de MQTT!"
    ```

    Si todo está configurado correctamente, deberías ver el mensaje "Hello, MQTT!" en la primera terminal donde te has suscrito.


Con estos pasos, deberías poder instalar y configurar Mosquitto MQTT en tu sistema Ubuntu.
