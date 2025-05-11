# Basis-Image: OpenJDK 21 (schlank)
FROM openjdk:21-jdk-slim

# Node.js + Tools installieren
RUN apt-get update && \
    apt-get install -y curl unzip gnupg ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis setzen
WORKDIR /usr/src/app

# Projektdateien kopieren
COPY . .

# Frontend in Spring Boot Static-Ordner kopieren
RUN mkdir -p backend/src/main/resources/static && \
    cp -r frontend/* backend/src/main/resources/static

# Gradle Wrapper ausführbar machen
RUN chmod +x backend/gradlew

# Spring Boot App bauen
WORKDIR /usr/src/app/backend
RUN ./gradlew build

# Port-Umgebung setzen (für Azure)
ENV PORT=80
EXPOSE 80

# Spring Boot App starten (mit Azure-kompatiblem Port)
CMD ["java", "-jar", "/usr/src/app/backend/build/libs/demo-0.0.1-SNAPSHOT.jar", "--server.port=${PORT}"]
