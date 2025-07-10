FROM openjdk:17-jdk-slim

WORKDIR /app

COPY discovery-service/target/discovery-service-*.jar app.jar

EXPOSE 8761

ENTRYPOINT ["java", "-jar", "app.jar"] 