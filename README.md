# Entrega-2-iot
Repositorio para la entrega de la segunda práctica en la asignatura de Desarrollo de aplicaciones IOT
# Miembros del equipo
    ** Claudia Viñals PErlado **
# Explicación de los pasos seguidos
## A. INSTALACIÓN MQTT MOSQUITTO

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
## B. Certificados
Existen dos opciones a la hora de crear los certificados:
1. **Generar certificados por comandos**: esto puede ser más complicado pero en este [enlace](https://blog.parravidales.es/aumenta-la-seguridad-de-mosquitto-anadiendo-tls/) explica como hacerlo paso a paso
2.   **Crear certificados por medio de archivo generate_certificates.sh**: Esto hace menos tedioso y complicado la generación de estos por linea de comandos y que sea mucho más sencillo. Comandos a ejecutar para ello:




# Instrucciones de uso
## IP de WSL
Poner la IP de la dirección en WSL para ello usar el comando 
    ```bash
    ip route show | grep -i default | awk '{ print $3}'
    ```

• Posibles vías de mejora
• Problemas / Retos encontrados
• Alternativas posibles
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
