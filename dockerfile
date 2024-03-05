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

# Ejecutamos los archivos de Python
CMD ["python", "/app/publicador_con.py"]
CMD ["python", "/app/subscriptor_con.py"]
