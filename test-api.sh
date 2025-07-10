#!/bin/bash

echo "Testing Spring Boot Microservices API..."
echo

# Wait for services to start
echo "Waiting for services to start..."
sleep 30

# Test API Gateway
echo "Testing API Gateway..."
curl -s http://localhost:8080/actuator/health
if [ $? -eq 0 ]; then
    echo "✓ API Gateway is running"
else
    echo "✗ API Gateway is not responding"
fi

# Test User Service
echo "Testing User Service..."
curl -s http://localhost:8081/users
if [ $? -eq 0 ]; then
    echo "✓ User Service is running"
else
    echo "✗ User Service is not responding"
fi

# Test Product Service
echo "Testing Product Service..."
curl -s http://localhost:8082/products
if [ $? -eq 0 ]; then
    echo "✓ Product Service is running"
else
    echo "✗ Product Service is not responding"
fi

# Test Order Service
echo "Testing Order Service..."
curl -s http://localhost:8083/orders
if [ $? -eq 0 ]; then
    echo "✓ Order Service is running"
else
    echo "✗ Order Service is not responding"
fi

# Test Eureka Dashboard
echo "Testing Eureka Dashboard..."
curl -s http://localhost:8761
if [ $? -eq 0 ]; then
    echo "✓ Eureka Dashboard is accessible"
else
    echo "✗ Eureka Dashboard is not accessible"
fi

echo
echo "API Test completed!"
echo
echo "Service URLs:"
echo "- Eureka Dashboard: http://localhost:8761"
echo "- API Gateway: http://localhost:8080"
echo "- User Service: http://localhost:8081"
echo "- Product Service: http://localhost:8082"
echo "- Order Service: http://localhost:8083" 