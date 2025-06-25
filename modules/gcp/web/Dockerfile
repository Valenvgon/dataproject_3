FROM python:3.10-slim

# Establece directorio de trabajo
WORKDIR /app

# Copia los archivos necesarios
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto del código
COPY . .

# Expone el puerto que usará Cloud Run
EXPOSE 8080

# Variable obligatoria para Cloud Run
ENV PORT 8080

# Comando de arranque (adaptado para Flask en Cloud Run)
CMD ["gunicorn", "-b", ":8080", "app:app"]