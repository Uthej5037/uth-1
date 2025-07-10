# Spring Boot Microservices Application

A comprehensive e-commerce microservices application built with Spring Boot, featuring user management, product catalog, order processing, and service discovery.

## Architecture Overview

This application follows a microservices architecture with the following components:

### Services

1. **Discovery Service (Eureka Server)** - Port 8761
   - Service discovery and registration
   - Central registry for all microservices

2. **Config Service** - Port 8888
   - Centralized configuration management
   - External configuration for all services

3. **API Gateway** - Port 8080
   - Single entry point for all client requests
   - Route requests to appropriate microservices
   - Load balancing and request filtering

4. **User Service** - Port 8081
   - User management and authentication
   - User registration, profile management
   - JWT token-based authentication

5. **Product Service** - Port 8082
   - Product catalog management
   - Product CRUD operations
   - Inventory management
   - Search and filtering capabilities

6. **Order Service** - Port 8083
   - Order processing and management
   - Integration with Product Service for stock validation
   - Order status tracking

## Technology Stack

- **Java 17**
- **Spring Boot 3.2.0**
- **Spring Cloud 2023.0.0**
- **Spring Data JPA**
- **H2 Database** (for development)
- **Eureka Server** (Service Discovery)
- **Spring Cloud Gateway** (API Gateway)
- **OpenFeign** (Service-to-Service Communication)
- **Spring Security** (Authentication & Authorization)
- **JWT** (JSON Web Tokens)
- **Maven** (Build Tool)

## Project Structure

```
microservices-parent/
├── discovery-service/          # Eureka Server
├── config-service/            # Spring Cloud Config Server
├── api-gateway/              # Spring Cloud Gateway
├── user-service/             # User Management Service
├── product-service/          # Product Catalog Service
└── order-service/           # Order Processing Service
```

## Getting Started

### Prerequisites

- Java 17 or higher
- Maven 3.6 or higher
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd microservices-parent
   ```

2. **Build all services**
   ```bash
   mvn clean install
   ```

3. **Start services in order**

   **Step 1: Start Discovery Service**
   ```bash
   cd discovery-service
   mvn spring-boot:run
   ```
   Access Eureka Dashboard: http://localhost:8761

   **Step 2: Start Config Service**
   ```bash
   cd ../config-service
   mvn spring-boot:run
   ```

   **Step 3: Start API Gateway**
   ```bash
   cd ../api-gateway
   mvn spring-boot:run
   ```

   **Step 4: Start User Service**
   ```bash
   cd ../user-service
   mvn spring-boot:run
   ```

   **Step 5: Start Product Service**
   ```bash
   cd ../product-service
   mvn spring-boot:run
   ```

   **Step 6: Start Order Service**
   ```bash
   cd ../order-service
   mvn spring-boot:run
   ```

### Alternative: Use the startup script

```bash
# Windows
startup.bat

# Linux/Mac
./startup.sh
```

## API Documentation

### API Gateway Endpoints

All requests go through the API Gateway at `http://localhost:8080`

#### User Service Endpoints
- `GET /api/users` - Get all users
- `GET /api/users/{id}` - Get user by ID
- `POST /api/users` - Create new user
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user
- `GET /api/users/username/{username}` - Get user by username
- `GET /api/users/email/{email}` - Get user by email

#### Product Service Endpoints
- `GET /api/products` - Get all products
- `GET /api/products/{id}` - Get product by ID
- `POST /api/products` - Create new product
- `PUT /api/products/{id}` - Update product
- `DELETE /api/products/{id}` - Delete product
- `GET /api/products/category/{category}` - Get products by category
- `GET /api/products/brand/{brand}` - Get products by brand
- `GET /api/products/search?name={name}` - Search products by name
- `GET /api/products/price-range?minPrice={min}&maxPrice={max}` - Get products by price range
- `GET /api/products/available` - Get available products
- `PUT /api/products/{id}/stock?quantity={qty}` - Update product stock

#### Order Service Endpoints
- `GET /api/orders` - Get all orders
- `GET /api/orders/{id}` - Get order by ID
- `POST /api/orders` - Create new order
- `PUT /api/orders/{id}/status?status={status}` - Update order status
- `PUT /api/orders/{id}/cancel` - Cancel order
- `GET /api/orders/user/{userId}` - Get orders by user ID
- `GET /api/orders/status/{status}` - Get orders by status
- `GET /api/orders/date-range?startDate={start}&endDate={end}` - Get orders by date range

### Sample API Requests

#### Create a User
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "password123",
    "firstName": "John",
    "lastName": "Doe",
    "phone": "+1234567890"
  }'
```

#### Create a Product
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "iPhone 15 Pro",
    "description": "Latest iPhone with advanced features",
    "price": 999.99,
    "category": "Electronics",
    "brand": "Apple",
    "stockQuantity": 50,
    "imageUrl": "https://example.com/iphone15.jpg"
  }'
```

#### Create an Order
```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "orderItems": [
      {
        "productId": 1,
        "quantity": 2
      }
    ],
    "shippingAddress": "123 Main St, City, State 12345",
    "paymentMethod": "CREDIT_CARD",
    "notes": "Please deliver in the morning"
  }'
```

## Database Access

Each service has its own H2 database console accessible at:
- User Service: http://localhost:8081/h2-console
- Product Service: http://localhost:8082/h2-console
- Order Service: http://localhost:8083/h2-console

Database credentials:
- JDBC URL: `jdbc:h2:mem:servicedb` (replace 'service' with user/product/order)
- Username: `sa`
- Password: `password`

## Service Discovery

Eureka Dashboard: http://localhost:8761

View all registered services and their health status.

## Configuration

All services use Spring Cloud Config for centralized configuration. The config service is configured to use a Git repository for configuration files.

## Features

### User Service
- User registration and authentication
- Password encryption with BCrypt
- Role-based access control
- JWT token generation and validation
- User profile management

### Product Service
- Product catalog management
- Category and brand filtering
- Price range filtering
- Search functionality
- Stock management
- Product availability tracking

### Order Service
- Order creation and management
- Integration with Product Service for stock validation
- Order status tracking
- Order cancellation with stock restoration
- Date range filtering

### API Gateway
- Request routing to appropriate services
- Load balancing
- Cross-origin resource sharing (CORS)
- Request filtering and transformation

## Security

- Spring Security for authentication and authorization
- JWT tokens for stateless authentication
- Password encryption with BCrypt
- CORS configuration for cross-origin requests

## Monitoring and Health Checks

- Eureka for service discovery and health monitoring
- Spring Boot Actuator for health checks
- H2 console for database monitoring

## Development

### Adding New Services

1. Create a new module in the parent project
2. Add the module to the parent `pom.xml`
3. Configure the service with appropriate dependencies
4. Add service to Eureka client configuration
5. Update API Gateway routes

### Testing

Each service includes unit tests and integration tests. Run tests with:

```bash
mvn test
```

### Deployment

The application can be deployed to:
- Docker containers
- Kubernetes clusters
- Cloud platforms (AWS, Azure, GCP)

## Troubleshooting

### Common Issues

1. **Service not registering with Eureka**
   - Check if Discovery Service is running
   - Verify Eureka client configuration
   - Check network connectivity

2. **API Gateway not routing requests**
   - Verify service names in gateway configuration
   - Check if target services are running
   - Review gateway logs for errors

3. **Database connection issues**
   - Verify H2 database configuration
   - Check if database files are accessible
   - Review JPA configuration

### Logs

Check application logs for each service:
- Discovery Service: `logs/discovery-service.log`
- Config Service: `logs/config-service.log`
- API Gateway: `logs/api-gateway.log`
- User Service: `logs/user-service.log`
- Product Service: `logs/product-service.log`
- Order Service: `logs/order-service.log`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

---

**Note**: This is a development setup using H2 in-memory databases. For production, consider using persistent databases like PostgreSQL, MySQL, or MongoDB. 