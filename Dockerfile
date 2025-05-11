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

# React-Frontend bauen
WORKDIR /usr/src/app/frontend
RUN npm install && npm run build

# React-Build in Spring Boot Static-Ordner kopieren
RUN mkdir -p /usr/src/app/backend/src/main/resources/static && \
    cp -r build/* /usr/src/app/backend/src/main/resources/static

# Gradle Wrapper ausführbar machen und Backend bauen
WORKDIR /usr/src/app/backend
RUN chmod +x ./gradlew && ./gradlew build

# Azure-kompatibler Port
ENV PORT=80
EXPOSE 80

# App starten mit dynamischem JAR-Namen
CMD ["sh", "-c", "java -jar backend/build/libs/*.jar --server.port=${PORT}"]
