# Entrega-2-iot
Repositorio para la entrega de la segunda práctica en la asignatura de Desarrollo de aplicaciones IOT
# Miembros del equipo
    ** Claudia Viñals PErlado **
# Explicación de los pasos seguidos
## A. Entorno
1. Crear [docker-compose.yaml](Entrega-2-iot/docker-compose.yaml) con las configuraciones de mosquitto.
2. Ejecutar el contenedor:
    ```bash
    docker-compose up -d
    ```
3. Reinicia el contenedor:
Después de realizar estos cambios reiniciar tu contenedor Mosquitto para que los cambios surtan efecto.
    ```bash
    docker-compose restart mosquitto
    ```
## B. Certificados
Existen dos opciones a la hora de crear los certificados:
1. **Generar certificados por comandos**: esto puede ser más complicado pero en este [enlace](https://blog.parravidales.es/aumenta-la-seguridad-de-mosquitto-anadiendo-tls/) explica como hacerlo paso a paso
2.   **Crear certificados por medio de archivo generate_certificates.sh**: Esto hace menos tedioso y complicado la generación de estos por linea de comandos y que sea mucho más sencillo. Comandos a ejecutar para ello, ir a la carpeta donde se alamcenara el archivo 'generate_certificates.sh':
    a. Editar el nombre de la variable CLIENT_BASE_NAME para que conindica con la del equipo.
    b. Dar permisos al archivo: 
    ```bash
    chmod +x generate_certificates.sh
    ```
    c. Ejecutar el Script, rellenar el apartado de contraseñas, hay que escribir siempre la misma para que al firmar no halla problemas.
    ```bash
    ./generate_certificates.sh
    ```
Una vez se hagan los certificados se puede poner la configuración por usuarios. Esto se hace por medio del comando:
    ```bash
    docker exec -it mosquitto mosquitto_passwd -c /home/cvp/Entrega-2-iot/app/contras "admin"
    ```
    Donde admin es el nombre del usuario y en la terminar escribiremos la contraseña. Este nombre de usuario y contraseña luego seran los mismos que se escribiran en los campos de python

Dar permisos a mosquitto para poder leer los archivos

    ```bash
    chmod 755 /home/cvp/Entrega-2-iot/mosquitto/certs
    ```

    para comprobar que se han otorgado 
# C.Configurar mosquitto.conf
Una vez ya se tienen todos los certificados y hemos hecho una prueba de que mosquito funciona sin seguridad es hora de editar el archivo de configuración de mosquitto. Aqui se indicaran los certificados, puertos, ajustes, etc. Como no se puede editar debido a permisos sin el nano hay un archivo llamado  [mosquito_boceto](mosquito_boceto.txt) donde he hecho todas las configuraciones y una vez listas las he pegado en el documento.
Comandos para editar el documento:
- Abrir el documento: 
    ```bash
    sudo nano /etc/mosquitto/mosquitto.conf
    ```
    - Una vez dentro para guardar los cambio hacer ctrl + o, luego enter y para salir ctrl + x
- Actualizar servicio de mosquitto:
    ```bash
    sudo systemctl restart mosquitto
    ```
    



# Instrucciones de uso
## IP de WSL
Las dirección donde esta el broker no es la misma que la del ordenador por ello hay que consultar la ip y ponerla en el archivo de python como tambien cuando se consulta por consola, para ello usar el comando. 
    ```bash
    ip route show | grep -i default | awk '{ print $3}'
    ```
    [Fuente](https://learn.microsoft.com/es-es/windows/wsl/networking)

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
