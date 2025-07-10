FROM openjdk:17-jdk-slim

WORKDIR /app

COPY user-service/target/user-service-*.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"] 