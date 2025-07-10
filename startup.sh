#!/bin/bash

echo "Starting Spring Boot Microservices Application..."
echo

echo "Building all services..."
mvn clean install -DskipTests
if [ $? -ne 0 ]; then
    echo "Build failed! Please check the errors above."
    exit 1
fi

echo
echo "Starting services in order..."
echo

echo "1. Starting Discovery Service (Eureka Server)..."
cd discovery-service && mvn spring-boot:run > ../logs/discovery-service.log 2>&1 &
DISCOVERY_PID=$!
cd ..
sleep 10

echo "2. Starting Config Service..."
cd config-service && mvn spring-boot:run > ../logs/config-service.log 2>&1 &
CONFIG_PID=$!
cd ..
sleep 10

echo "3. Starting API Gateway..."
cd api-gateway && mvn spring-boot:run > ../logs/api-gateway.log 2>&1 &
GATEWAY_PID=$!
cd ..
sleep 10

echo "4. Starting User Service..."
cd user-service && mvn spring-boot:run > ../logs/user-service.log 2>&1 &
USER_PID=$!
cd ..
sleep 10

echo "5. Starting Product Service..."
cd product-service && mvn spring-boot:run > ../logs/product-service.log 2>&1 &
PRODUCT_PID=$!
cd ..
sleep 10

echo "6. Starting Order Service..."
cd order-service && mvn spring-boot:run > ../logs/order-service.log 2>&1 &
ORDER_PID=$!
cd ..
sleep 10

echo
echo "All services are starting..."
echo
echo "Service URLs:"
echo "- Eureka Dashboard: http://localhost:8761"
echo "- API Gateway: http://localhost:8080"
echo "- User Service: http://localhost:8081"
echo "- Product Service: http://localhost:8082"
echo "- Order Service: http://localhost:8083"
echo
echo "Database Consoles:"
echo "- User Service DB: http://localhost:8081/h2-console"
echo "- Product Service DB: http://localhost:8082/h2-console"
echo "- Order Service DB: http://localhost:8083/h2-console"
echo
echo "Process IDs:"
echo "- Discovery Service: $DISCOVERY_PID"
echo "- Config Service: $CONFIG_PID"
echo "- API Gateway: $GATEWAY_PID"
echo "- User Service: $USER_PID"
echo "- Product Service: $PRODUCT_PID"
echo "- Order Service: $ORDER_PID"
echo
echo "To stop all services, run: kill $DISCOVERY_PID $CONFIG_PID $GATEWAY_PID $USER_PID $PRODUCT_PID $ORDER_PID"
echo
echo "Press Ctrl+C to stop all services..."
trap 'echo "Stopping all services..."; kill $DISCOVERY_PID $CONFIG_PID $GATEWAY_PID $USER_PID $PRODUCT_PID $ORDER_PID 2>/dev/null; exit' INT
wait 