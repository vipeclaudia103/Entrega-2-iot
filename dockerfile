# Usa una imagen base de Python
FROM python:3.9

# Instala Mosquitto
RUN apt-get update && apt-get install -y mosquitto mosquitto-clients

# Copia el archivo de requisitos e instala las dependencias de Python
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

# Copia el script de generación de certificados al contenedor
COPY generate_certificates.sh /usr/src/app/

# Cambia el directorio de trabajo
WORKDIR /usr/src/app

# Ejecuta el script de generación de certificados
RUN chmod +x generate_certificates.sh && ./generate_certificates.sh

# Copia tu código de la aplicación al contenedor
COPY . /app

# Establece el directorio de trabajo
WORKDIR /app

# Comando predeterminado a ejecutar cuando se inicie el contenedor
CMD ["python", "app.py"]
