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

# Frontend statisch ins Backend kopieren (damit Spring Boot sie bereitstellt)
RUN mkdir -p backend/src/main/resources/static && \
    cp frontend/*.json backend/src/main/resources/static/ && \
    cp frontend/*.html backend/src/main/resources/static/ && \
    cp frontend/*.ico backend/src/main/resources/static/ || true

# Gradle Wrapper ausführbar machen und App bauen
WORKDIR /usr/src/app/backend
RUN chmod +x gradlew && ./gradlew build

# Azure-kompatibel: Port 80 verwenden
EXPOSE 80
ENV PORT=80

# App starten
CMD ["java", "-jar", "build/libs/demo-0.0.1-SNAPSHOT.jar", "--server.port=80"]
