FROM openjdk:21-jdk-slim

# Node.js + Tools installieren
RUN apt-get update && \
    apt-get install -y curl unzip gnupg ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis
WORKDIR /usr/src/app

# Projektdateien kopieren
COPY . .

# Frontend-Abhängigkeiten installieren
WORKDIR /usr/src/app/frontend
RUN npm install

# Statische Dateien ins Backend kopieren
RUN mkdir -p /usr/src/app/backend/src/main/resources/static && \
    cp index.html model.json favicon.ico /usr/src/app/backend/src/main/resources/static/ && \
    cp -r node_modules/path-framework /usr/src/app/backend/src/main/resources/static/

# Backend bauen
WORKDIR /usr/src/app/backend
RUN chmod +x gradlew && ./gradlew build

# Azure-kompatibel: Port 80 verwenden
EXPOSE 80
ENV PORT=80

# App starten
CMD ["java", "-jar", "build/libs/demo-0.0.1-SNAPSHOT.jar", "--server.port=80"]
