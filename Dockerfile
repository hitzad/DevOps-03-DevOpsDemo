# Basis-Image: OpenJDK 21
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

# Nur Abhängigkeiten installieren (kein build!)
WORKDIR /usr/src/app/frontend
RUN npm install

# HTML + JS in Spring Boot static/ kopieren
RUN mkdir -p /usr/src/app/backend/src/main/resources/static && \
    cp -r . /usr/src/app/backend/src/main/resources/static

# Spring Boot build
WORKDIR /usr/src/app/backend
RUN chmod +x ./gradlew && ./gradlew build

# Port setzen (für Azure)
ENV PORT=80
EXPOSE 80

# Start Spring Boot App mit generischem Jar
CMD ["sh", "-c", "java -jar backend/build/libs/*.jar --server.port=${PORT}"]
