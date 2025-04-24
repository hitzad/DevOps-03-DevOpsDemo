FROM openjdk:21-jdk-slim

# Node.js installieren (wenn du später mal ein echtes Build brauchst)
RUN apt-get update && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

WORKDIR /usr/src/app
COPY . .

# HTML in Spring Boot einbinden
RUN mkdir -p backend/src/main/resources/static
RUN cp -r frontend/* backend/src/main/resources/static

# Spring Boot App bauen
RUN cd backend && chmod +x gradlew && ./gradlew build

EXPOSE 8080
CMD ["java", "-jar", "/usr/src/app/backend/build/libs/demo-0.0.1-SNAPSHOT.jar"]
