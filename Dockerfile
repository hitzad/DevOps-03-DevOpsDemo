FROM openjdk:21-jdk-slim

# Node.js & system tools installieren
RUN apt-get update && \
    apt-get install -y curl unzip gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs npm && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis setzen
WORKDIR /usr/src/app

# Projektdateien kopieren
COPY . .

# Frontend-Dateien ins Spring-Backend kopieren
RUN mkdir -p backend/src/main/resources/static && \
    cp -r frontend/* backend/src/main/resources/static

# Gradle Wrapper ausführbar machen
RUN chmod +x backend/gradlew

# Spring Boot App mit dem Wrapper bauen
WORKDIR /usr/src/app/backend
RUN ./gradlew build

# Port öffnen und App starten
EXPOSE 8080
CMD ["java", "-jar", "/usr/src/app/backend/build/libs/demo-0.0.1-SNAPSHOT.jar"]
