FROM openjdk:21-jdk-slim

# Node.js und Gradle installieren
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    nodejs \
    npm \
    gradle

# Arbeitsverzeichnis setzen
WORKDIR /usr/src/app

# Projektdateien kopieren
COPY . .

# Frontend-Dateien ins Spring-Backend kopieren
RUN mkdir -p backend/src/main/resources/static
RUN cp -r frontend/* backend/src/main/resources/static

# Spring Boot App bauen – mit systemweitem Gradle statt Wrapper
RUN cd backend && gradle build

# Port öffnen & App starten
EXPOSE 8080
CMD ["java", "-jar", "/usr/src/app/backend/build/libs/demo-0.0.1-SNAPSHOT.jar"]
