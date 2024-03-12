# Usamos una imagen base de Python
FROM python:3.10

# Definimos el directorio de trabajo en el contenedor
WORKDIR /app

# Copiamos el archivo requirements.txt al contenedor
COPY requirements.txt .

# Instalamos las dependencias desde el archivo requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copiamos los archivos de Python al directorio de trabajo del contenedor
COPY /app/* /app/

# Ejecutamos el script de publicación de Python
CMD ["python", "/app/publicador_con.py"]
# Si deseas ejecutar el script de subscripción en su lugar, comenta la línea anterior y descomenta la siguiente:
CMD ["python", "/app/subscriptor_con.py"]
