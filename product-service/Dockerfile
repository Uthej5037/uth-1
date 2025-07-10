FROM openjdk:17-jdk-slim

WORKDIR /app

COPY product-service/target/product-service-*.jar app.jar

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "app.jar"] 