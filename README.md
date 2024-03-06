# Detalles del equipo
- **Miembros del equipo:** [Lista de miembros del equipo]
- **Tiempo invertido:** 24 horas
- **Repositorio**: (git_Hub)[https://github.com/vipeclaudia103/Entrega-2-iot.git]
# Explicación de los pasos seguidos
## Resumen
1. Estudio de certificados y estructura de conexión.
2. Creación del entorno sin seguridad y pruebas.
3. Creación de certificados de CA, servidor y clientes.
4. Creación del entorno con seguridad.
5. Pruebas de conectividad.
6. Gestión de errores.

## A. Entorno
1. Crear el archivo `docker-compose.yaml` con las configuraciones de Mosquitto.
2. Ejecutar el contenedor:
    ```bash
    docker-compose up -d
    ```
3. Reiniciar el contenedor:
    ```bash
    docker-compose restart mosquitto
    ```

### A.1 Ejecutar por terminal sin seguridad
1. Suscribirse a un tema:
    ```bash
    mosquitto_sub -h localhost -t saludo
    ```

2. Publicar un mensaje en el mismo tema:
    ```bash
    mosquitto_pub -h localhost -t saludo -m "¡Hola! Estás suscrito al topic saludo de MQTT."
    ```

## B. Certificados
Existen dos opciones para crear los certificados:

1. **Generar certificados mediante comandos:** Puede ser más complicado, pero [este enlace](https://blog.parravidales.es/aumenta-la-seguridad-de-mosquitto-anadiendo-tls/) explica cómo hacerlo paso a paso.

2. **Crear certificados mediante el archivo `generate_certificates.sh`:** Esto simplifica la generación de certificados mediante un script. Pasos a seguir:
    a. Editar el nombre de la variable `CLIENT_BASE_NAME` para que coincida con el del equipo.
    b. Dar permisos al archivo:
    ```bash
    chmod +x generate_certificates.sh
    ```
    c. Ejecutar el script y rellenar las contraseñas requeridas.
    ```bash
    ./generate_certificates.sh
    ```
    Si es necesario recrear los certificados, eliminar los anteriores con los siguientes comandos:
    ```bash
    sudo rm -r /home/cvp/Entrega-2-iot/mosquitto/server_certs/*
    sudo rm -r /home/cvp/Entrega-2-iot/certs_clientes/*
    ```

    ### Opcional: Creación de usuarios
    Después de generar los certificados, se puede configurar la autenticación por usuarios con el siguiente comando:
    ```bash
    docker exec -it mosquitto sh
    mosquitto_passwd -c /mosquitto/config/passwd admin
    ```
    Reemplazar `admin` con el nombre de usuario y seguir las instrucciones para establecer la contraseña.

## C. Configurar entorno
Editar el archivo de configuración de Mosquitto para apuntar a los certificados generados y configurar la seguridad. Para facilitar la edición, otorgar permisos de escritura al archivo:
```bash
chmod 666 /home/cvp/Entrega-2-iot/mosquitto/config/mosquitto.conf
```
Actualizar el servicio de Mosquitto para aplicar los cambios:
```bash
sudo systemctl restart mosquitto
```

El contenido del archivo sin seguridad debe ser:
```
listener 1883
allow_anonymous true
```

El contenido del archivo con seguridad debe incluir las direcciones a los archivos de Mosquitto y las opciones de permitir anónimos negada.

## D. Pruebas de conectividad por consola y Python
### Configuración de los archivos de Python
Crear un Dockerfile para ejecutar los archivos de Python, instalando la librería Paho indicada en los requisitos. Si se han configurado usuarios, añadir las claves correspondientes en los campos adecuados.

### Ejecutar por terminal con seguridad
Abrir la consola dentro del contenedor:
```bash
docker exec -it mosquitto sh
```

1. Publicar un mensaje en el mismo tema:
```bash
echo "Hola MQTT" | mosquitto_sub -h Entrega-2 -p 8883 --cafile /mosquitto/certs/ca.crt --cert /mosquitto/certs/ClaudiaPortatil3.crt --key /mosquitto/certs/ClaudiaPortatil3.key --username admin --pw admin -t "topic/1"
```

2. Suscribirse a un tema:
```bash
mosquitto_sub -h Entrega-2 -p 8883 --cafile /home/cvp/Entrega-2-iot/mosquitto/server_certs/ca.crt --cert /mosquitto/certs/ClaudiaPortatil4.crt --key /mosquitto/certs/ClaudiaPortatil4.key --username admin --pw admin -t "topic/1"
```

Si todo está configurado correctamente, deberías ver el mensaje "Hola MQTT" en la primera terminal donde te has suscrito.

# Instrucciones de uso
## Confirmar permisos
Al ejecutar el archivo de creación de permisos, verificar que todos los archivos tengan permisos de lectura por el contenedor y por el usuario.

## IP de WSL
Como el mosquitto se ejecuta en el contenedor el broker es el hostname del contenedor, esta cambia y no coincide tampoco con la IP del WSL ni la del ordenador. Por ello en el docker-compose hay una linea donde declaramos que el hostname es 'Entrega-2' de forma que aunque se elimine o resetee el contenedor siempre se enciende con el mismo hostname. La IP del contenedor es diferente se puede consultar abriendo la terminar del dontenedor con el comando 'docker exec -it mosquitto sh' y usando 'hostname -i'

La IP del contenedor coincice con la de WLS para comprobarlo pueden utilizarse estas dos líneas.
    ```bash
    ip route show | grep -i default | awk '{ print $3}' #IP WSL
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mosquitto #IP contenedor
    ```
 

## EJECUTAR POR TERMINAL CON SEGURIDAD
Abrir la consola de dentro del contenedor:
    ```bash
    docker exec -it mosquitto sh
    ``` 
Importante poner el hostname del contenedor donde se ejecuta el 
1.  Publica un mensaje en el mismo tema:

    ```bash
     echo "Hola MQTT" | mosquitto_pub -h Entrega-2 -p 8883 --cafile /mosquitto/certs/ca.crt --cert /mosquitto/certs/ClaudiaPortatil3.crt --key /mosquitto/certs/ClaudiaPortatil3.key --username admin --pw admin -t "topic/1" -l

    ```

2.  Suscríbete a un tema:

    ```bash
    mosquitto_sub -h Entrega-2 -p 8883 --cafile /mosquitto/certs/ca.crt --cert /mosquitto/certs/ClaudiaPortatil3.crt --key /mosquitto/certs/ClaudiaPortatil3.key --username admin --pw admin -t "topic/1"
    ```

    Si todo está configurado correctamente, deberías ver el mensaje "Hello, MQTT!" en la primera terminal donde te has suscrito.

El segmento de código y texto proporcionado está bien estructurado y ofrece instrucciones claras sobre cómo ejecutar comandos en la terminal para publicar y suscribirse a temas MQTT de forma segura. Sin embargo, aquí hay algunas sugerencias de mejora para la sección de "Posibles vías de mejora", "Problemas / Retos encontrados" y "Alternativas posibles":

## Posibles vías de mejora
- **Creación de los certificados con SAN sin errores:** Aunque se han comentado los certificados con Subject Alternative Name (SAN), es importante investigar y resolver los errores de configuración para implementar esta función correctamente. Esto puede mejorar la seguridad y la flexibilidad de la configuración de certificados.
- **No ejecutar el broker en el contenedor:** Considera la posibilidad de ejecutar el broker MQTT fuera del contenedor para facilitar la configuración del servidor y el acceso a él. Esto puede simplificar la gestión y mejorar la interoperabilidad con otras aplicaciones y servicios.

## Problemas / Retos encontrados
- **Versiones y compatibilidad:** A menudo, las versiones de software y las dependencias pueden causar problemas de compatibilidad. Es esencial mantenerse al día con las actualizaciones y revisar las dependencias para garantizar una integración suave y evitar conflictos.
- **Información confusa:** Si la documentación o la información proporcionada son confusas, considera revisar y clarificar los pasos o conceptos problemáticos. Esto puede incluir agregar ejemplos adicionales o explicaciones detalladas para facilitar la comprensión.
- **Estructuración del proyecto:** Mantener una estructura de proyecto clara y organizada puede ayudar a facilitar el desarrollo, la depuración y el mantenimiento a largo plazo. Asegúrate de seguir las mejores prácticas de estructuración de proyectos para evitar problemas de escalabilidad y mantenibilidad.
- **Permisos para los diferentes usuarios:** Administrar adecuadamente los permisos de usuario es crucial para garantizar la seguridad y la integridad del sistema. Asegúrate de asignar los permisos adecuados a los usuarios según sus roles y responsabilidades para evitar posibles brechas de seguridad.

## Alternativas posibles
- **Encriptación de datos de extremo a extremo:** Además de implementar seguridad en la capa de transporte, considera la posibilidad de cifrar los datos de extremo a extremo utilizando algoritmos como AES. Esto proporciona una capa adicional de seguridad para proteger los datos mientras están en tránsito y en reposo.
- **Firewalls y políticas de seguridad de red:** Junto con las medidas de seguridad en la aplicación y en la capa de transporte, implementa firewalls y políticas de seguridad de red para controlar y monitorear el tráfico MQTT. Esto puede ayudar a prevenir ataques externos y garantizar la integridad de la red y los datos.
- **OAuth**: protocolo de autorización que permite a las aplicaciones obtener acceso limitado a recursos en un servidor en nombre de un propietario de recursos. Puedes utilizar OAuth para autorizar el acceso a tu servidor MQTT en lugar de depender únicamente de certificados.
