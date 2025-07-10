package com.uthej.order.service;

import com.uthej.order.client.ProductClient;
import com.uthej.order.client.ProductResponse;
import com.uthej.order.dto.OrderDto;
import com.uthej.order.dto.OrderItemDto;
import com.uthej.order.model.Order;
import com.uthej.order.model.OrderItem;
import com.uthej.order.model.OrderStatus;
import com.uthej.order.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class OrderService {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private ProductClient productClient;
    
    public List<OrderDto> getAllOrders() {
        return orderRepository.findAll().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public Optional<OrderDto> getOrderById(Long id) {
        return orderRepository.findById(id)
                .map(this::convertToDto);
    }
    
    public List<OrderDto> getOrdersByUserId(Long userId) {
        return orderRepository.findByUserId(userId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<OrderDto> getOrdersByStatus(OrderStatus status) {
        return orderRepository.findByStatus(status).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<OrderDto> getOrdersByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return orderRepository.findByOrderDateBetween(startDate, endDate).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public OrderDto createOrder(OrderDto orderDto) {
        // Validate products and update stock
        for (OrderItemDto item : orderDto.getOrderItems()) {
            ProductResponse product = productClient.getProductById(item.getProductId());
            if (product == null || !product.isActive()) {
                throw new RuntimeException("Product not found or inactive: " + item.getProductId());
            }
            
            if (product.getStockQuantity() < item.getQuantity()) {
                throw new RuntimeException("Insufficient stock for product: " + product.getName());
            }
            
            // Update stock
            Boolean stockUpdated = productClient.updateStock(item.getProductId(), item.getQuantity());
            if (!stockUpdated) {
                throw new RuntimeException("Failed to update stock for product: " + item.getProductId());
            }
            
            // Set product details
            item.setProductName(product.getName());
            item.setUnitPrice(product.getPrice());
            item.setTotalPrice(product.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
        }
        
        // Calculate total amount
        BigDecimal totalAmount = orderDto.getOrderItems().stream()
                .map(OrderItemDto::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        orderDto.setTotalAmount(totalAmount);
        orderDto.setStatus(OrderStatus.PENDING);
        
        Order order = convertToEntity(orderDto);
        Order savedOrder = orderRepository.save(order);
        return convertToDto(savedOrder);
    }
    
    public OrderDto updateOrderStatus(Long id, OrderStatus status) {
        Optional<Order> existingOrder = orderRepository.findById(id);
        if (existingOrder.isEmpty()) {
            throw new RuntimeException("Order not found");
        }
        
        Order order = existingOrder.get();
        order.setStatus(status);
        
        Order savedOrder = orderRepository.save(order);
        return convertToDto(savedOrder);
    }
    
    public void cancelOrder(Long id) {
        Optional<Order> order = orderRepository.findById(id);
        if (order.isPresent()) {
            Order o = order.get();
            if (o.getStatus() == OrderStatus.PENDING || o.getStatus() == OrderStatus.CONFIRMED) {
                o.setStatus(OrderStatus.CANCELLED);
                orderRepository.save(o);
                
                // Restore stock
                for (OrderItem item : o.getOrderItems()) {
                    productClient.updateStock(item.getProductId(), -item.getQuantity());
                }
            }
        }
    }
    
    private OrderDto convertToDto(Order order) {
        OrderDto dto = new OrderDto();
        dto.setId(order.getId());
        dto.setUserId(order.getUserId());
        dto.setTotalAmount(order.getTotalAmount());
        dto.setStatus(order.getStatus());
        dto.setShippingAddress(order.getShippingAddress());
        dto.setBillingAddress(order.getBillingAddress());
        dto.setPaymentMethod(order.getPaymentMethod());
        dto.setNotes(order.getNotes());
        dto.setOrderDate(order.getOrderDate());
        dto.setUpdatedAt(order.getUpdatedAt());
        
        if (order.getOrderItems() != null) {
            List<OrderItemDto> itemDtos = order.getOrderItems().stream()
                    .map(this::convertToItemDto)
                    .collect(Collectors.toList());
            dto.setOrderItems(itemDtos);
        }
        
        return dto;
    }
    
    private Order convertToEntity(OrderDto dto) {
        Order order = new Order();
        order.setUserId(dto.getUserId());
        order.setTotalAmount(dto.getTotalAmount());
        order.setStatus(dto.getStatus());
        order.setShippingAddress(dto.getShippingAddress());
        order.setBillingAddress(dto.getBillingAddress());
        order.setPaymentMethod(dto.getPaymentMethod());
        order.setNotes(dto.getNotes());
        
        if (dto.getOrderItems() != null) {
            List<OrderItem> items = dto.getOrderItems().stream()
                    .map(itemDto -> convertToItemEntity(itemDto, order))
                    .collect(Collectors.toList());
            order.setOrderItems(items);
        }
        
        return order;
    }
    
    private OrderItemDto convertToItemDto(OrderItem item) {
        OrderItemDto dto = new OrderItemDto();
        dto.setId(item.getId());
        dto.setProductId(item.getProductId());
        dto.setProductName(item.getProductName());
        dto.setQuantity(item.getQuantity());
        dto.setUnitPrice(item.getUnitPrice());
        dto.setTotalPrice(item.getTotalPrice());
        return dto;
    }
    
    private OrderItem convertToItemEntity(OrderItemDto dto, Order order) {
        OrderItem item = new OrderItem();
        item.setOrder(order);
        item.setProductId(dto.getProductId());
        item.setProductName(dto.getProductName());
        item.setQuantity(dto.getQuantity());
        item.setUnitPrice(dto.getUnitPrice());
        item.setTotalPrice(dto.getTotalPrice());
        return item;
    }
} 