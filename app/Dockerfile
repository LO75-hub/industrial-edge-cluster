# Image Python légère
FROM python:3.9-slim

WORKDIR /app

# Installation des dépendances
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copie du code source
COPY src/ src/

# Exposition du port
EXPOSE 5000

# Démarrage
CMD ["python", "src/main.py"]
