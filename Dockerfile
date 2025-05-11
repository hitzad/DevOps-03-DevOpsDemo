FROM openjdk:21-jdk-slim

# Node.js installieren
RUN apt-get update && \
    apt-get install -y curl unzip gnupg ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis setzen
WORKDIR /usr/src/app

# Projektdateien kopieren
COPY . .

# React-App bauen
WORKDIR /usr/src/app/frontend
RUN npm install && npm run build

# React-Build ins Spring Boot static-Verzeichnis kopieren
RUN mkdir -p /usr/src/app/backend/src/main/resources/static && \
    cp -r build/* /usr/src/app/backend/src/main/resources/static

# Gradle Wrapper ausführbar machen & Backend bauen
WORKDIR /usr/src/app/backend
RUN chmod +x ./gradlew && ./gradlew build

# Azure-Port setzen
ENV PORT=80
EXPOSE 80

# App starten
CMD ["sh", "-c", "java -jar build/libs/*.jar --server.port=${PORT}"]
