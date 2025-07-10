@echo off
echo Testing Spring Boot Microservices API...
echo.

REM Wait for services to start
echo Waiting for services to start...
timeout /t 30 /nobreak > nul

REM Test API Gateway
echo Testing API Gateway...
curl -s http://localhost:8080/actuator/health > nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ API Gateway is running
) else (
    echo ✗ API Gateway is not responding
)

REM Test User Service
echo Testing User Service...
curl -s http://localhost:8081/users > nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ User Service is running
) else (
    echo ✗ User Service is not responding
)

REM Test Product Service
echo Testing Product Service...
curl -s http://localhost:8082/products > nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ Product Service is running
) else (
    echo ✗ Product Service is not responding
)

REM Test Order Service
echo Testing Order Service...
curl -s http://localhost:8083/orders > nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ Order Service is running
) else (
    echo ✗ Order Service is not responding
)

REM Test Eureka Dashboard
echo Testing Eureka Dashboard...
curl -s http://localhost:8761 > nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ Eureka Dashboard is accessible
) else (
    echo ✗ Eureka Dashboard is not accessible
)

echo.
echo API Test completed!
echo.
echo Service URLs:
echo - Eureka Dashboard: http://localhost:8761
echo - API Gateway: http://localhost:8080
echo - User Service: http://localhost:8081
echo - Product Service: http://localhost:8082
echo - Order Service: http://localhost:8083
echo.
pause 