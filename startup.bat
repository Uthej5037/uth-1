@echo off
echo Starting Spring Boot Microservices Application...
echo.

echo Building all services...
call mvn clean install -DskipTests
if %errorlevel% neq 0 (
    echo Build failed! Please check the errors above.
    pause
    exit /b 1
)

echo.
echo Starting services in order...
echo.

echo 1. Starting Discovery Service (Eureka Server)...
start "Discovery Service" cmd /k "cd discovery-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo 2. Starting Config Service...
start "Config Service" cmd /k "cd config-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo 3. Starting API Gateway...
start "API Gateway" cmd /k "cd api-gateway && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo 4. Starting User Service...
start "User Service" cmd /k "cd user-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo 5. Starting Product Service...
start "Product Service" cmd /k "cd product-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo 6. Starting Order Service...
start "Order Service" cmd /k "cd order-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo.
echo All services are starting...
echo.
echo Service URLs:
echo - Eureka Dashboard: http://localhost:8761
echo - API Gateway: http://localhost:8080
echo - User Service: http://localhost:8081
echo - Product Service: http://localhost:8082
echo - Order Service: http://localhost:8083
echo.
echo Database Consoles:
echo - User Service DB: http://localhost:8081/h2-console
echo - Product Service DB: http://localhost:8082/h2-console
echo - Order Service DB: http://localhost:8083/h2-console
echo.
echo Press any key to exit...
pause > nul 