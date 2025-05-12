# Basis-Image mit Java
FROM openjdk:21-jdk-slim

# Node.js und Tools installieren
RUN apt-get update && \
    apt-get install -y curl unzip gnupg ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis setzen
WORKDIR /usr/src/app

# Projektdateien kopieren
COPY . .

# Statische Frontend-Dateien ins Backend-Static-Verzeichnis kopieren
RUN mkdir -p backend/src/main/resources/static && \
    cp frontend/index.html backend/src/main/resources/static/ && \
    cp frontend/favicon.ico backend/src/main/resources/static/ || true && \
    cp frontend/*.json backend/src/main/resources/static/ || true

# Spring Boot App bauen
WORKDIR /usr/src/app/backend
RUN chmod +x gradlew && ./gradlew build

# Port dynamisch über Azure (z. B. 80, 12345, ...)
EXPOSE 8080

# Starte App mit Port aus ENV-Variable
CMD ["sh", "-c", "java -jar build/libs/demo-0.0.1-SNAPSHOT.jar --server.port=$PORT"]


