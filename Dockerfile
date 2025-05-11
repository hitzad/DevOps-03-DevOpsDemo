# Basis-Image mit Java für Spring Boot
FROM openjdk:21-jdk-slim

# Node.js & Tools installieren
RUN apt-get update && \
    apt-get install -y curl unzip gnupg ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis setzen
WORKDIR /usr/src/app

# Projektdateien kopieren
COPY . .

# Frontend-Abhängigkeiten installieren
WORKDIR /usr/src/app/frontend
RUN npm install

# Frontend-Dateien ins Spring Boot static-Verzeichnis kopieren
WORKDIR /usr/src/app
RUN mkdir -p backend/src/main/resources/static && \
    cp -r frontend/* backend/src/main/resources/static

# Gradle Wrapper ausführbar machen & App bauen
WORKDIR /usr/src/app/backend
RUN chmod +x gradlew && ./gradlew build

# Azure-kompatibel: Port 80 nutzen
ENV PORT=80
EXPOSE 80

# Start der Spring Boot App mit Port 80
CMD ["java", "-jar", "/usr/src/app/backend/build/libs/demo-0.0.1-SNAPSHOT.jar", "--server.port=${PORT}"]
