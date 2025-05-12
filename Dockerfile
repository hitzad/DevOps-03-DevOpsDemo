# Basis-Image mit Java
FROM openjdk:21-jdk-slim

# Arbeitsverzeichnis setzen
WORKDIR /usr/src/app

# Projektdateien kopieren
COPY . .

# Statische Frontend-Dateien in das Spring Boot Static-Verzeichnis kopieren
RUN mkdir -p backend/src/main/resources/static && \
    cp frontend/index.html backend/src/main/resources/static/ && \
    cp frontend/favicon.ico backend/src/main/resources/static/ && \
    cp frontend/*.json backend/src/main/resources/static/ || true

# Spring Boot App bauen
WORKDIR /usr/src/app/backend
RUN chmod +x gradlew && ./gradlew build

# Azure-kompatibel: Port 80 verwenden
ENV PORT=80
EXPOSE 80

# Spring Boot starten auf Port 80
CMD ["sh", "-c", "java -jar build/libs/demo-0.0.1-SNAPSHOT.jar --server.port=$PORT"]


