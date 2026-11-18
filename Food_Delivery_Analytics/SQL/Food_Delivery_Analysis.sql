CREATE DATABASE food_delivery_db;

USE food_delivery_db;

-- Create the customers table

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE,
    customer_segment VARCHAR(30)
);

--  Verify the data

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT * FROM customers
LIMIT 10;

-- Create restaurants table

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(100),
    cuisine VARCHAR(50),
    city VARCHAR(50),
    average_menu_price DECIMAL(10,2),
    restaurant_rating DECIMAL(3,2),
    is_active TINYINT
);

-- Verify the data

SELECT COUNT(*) AS total_restaurants
FROM restaurants;

SELECT * FROM restaurants
LIMIT 10;

-- Create Delivery Partners Table

CREATE TABLE delivery_partners (
    partner_id INT PRIMARY KEY,
    partner_name VARCHAR(100),
    city VARCHAR(50),
    vehicle_type VARCHAR(30),
    partner_rating DECIMAL(3,2),
    joining_date DATE
);

-- Verify the data

SELECT COUNT(*) AS total_partners
FROM delivery_partners;

SELECT * FROM delivery_partners
LIMIT 10;

-- Create Orders Table

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    partner_id INT,
    order_datetime DATETIME,
    order_status VARCHAR(20),
    payment_method VARCHAR(30),
    subtotal DECIMAL(10,2),
    delivery_fee DECIMAL(10,2),
    discount DECIMAL(10,2),
    tax DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    estimated_delivery_minutes INT,
    actual_delivery_minutes INT,
    preparation_time_minutes INT,
    delivery_distance_km DECIMAL(6,2),
    cancellation_reason VARCHAR(100),
    refund_amount DECIMAL(10,2),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),

    FOREIGN KEY (partner_id)
        REFERENCES delivery_partners(partner_id)
);

-- Verify the data

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT order_status, COUNT(*) AS total
FROM orders
GROUP BY order_status;

-- Create Ratings Table


CREATE TABLE ratings (
    rating_id INT PRIMARY KEY,
    order_id INT,
    customer_id INT,
    restaurant_id INT,
    rating INT,
    review_text VARCHAR(255),
    rating_datetime DATETIME,

    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

-- Verify the data


SELECT COUNT(*) AS total_ratings
FROM ratings;

SELECT * FROM ratings
LIMIT 10;


SELECT 'Customers' AS table_name, COUNT(*) AS total
FROM customers

UNION ALL

SELECT 'Restaurants', COUNT(*)
FROM restaurants

UNION ALL

SELECT 'Delivery Partners', COUNT(*)
FROM delivery_partners

UNION ALL

SELECT 'Orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'Ratings', COUNT(*)
FROM ratings;

-- Basic SQL Business Analysis

-- Total number of orders

SELECT COUNT(*) AS Total_Orders
FROM orders;

-- Order status analysis

SELECT
    order_status,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY order_status;

-- Total revenue

SELECT
    ROUND(SUM(total_amount), 2) AS Total_Revenue
FROM orders
WHERE order_status = 'Delivered';

-- Average Order Value (AOV)

SELECT
    ROUND(AVG(total_amount), 2) AS Average_Order_Value
FROM orders
WHERE order_status = 'Delivered';

-- Cancellation rate

SELECT
    ROUND(
        COUNT(CASE WHEN order_status = 'Cancelled' THEN 1 END)
        * 100.0 / COUNT(*), 2
    ) AS Cancellation_Rate
FROM orders;

-- Average delivery time

SELECT
    ROUND(AVG(actual_delivery_minutes), 2) AS Average_Delivery_Time
FROM orders
WHERE order_status = 'Delivered';

-- Q1 Top 10 Restaurants by Revenue

SELECT
    r.restaurant_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Q2 City-wise Revenue

SELECT
    r.city,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY r.city
ORDER BY total_revenue DESC;

-- Q3 Cuisine-wise Revenue

SELECT
    r.cuisine,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY r.cuisine
ORDER BY total_revenue DESC;

-- Q4 Peak Ordering Hours

SELECT
    HOUR(order_datetime) AS order_hour,
    COUNT(*) AS total_orders
FROM orders
GROUP BY HOUR(order_datetime)
ORDER BY total_orders DESC;

-- Q5 Cancellation Reasons

SELECT
    cancellation_reason,
    COUNT(*) AS total_cancellations
FROM orders
WHERE order_status = 'Cancelled'
GROUP BY cancellation_reason
ORDER BY total_cancellations DESC;

-- Q6 Customer Ratings

SELECT
    ROUND(AVG(rating), 2) AS average_rating,
    COUNT(*) AS total_reviews
FROM ratings;

-- Q7 Delivery Partner Performance

SELECT
    d.partner_name,
    COUNT(o.order_id) AS delivered_orders,
    ROUND(AVG(o.actual_delivery_minutes), 2) AS avg_delivery_time
FROM orders o
JOIN delivery_partners d
    ON o.partner_id = d.partner_id
WHERE o.order_status = 'Delivered'
GROUP BY d.partner_id, d.partner_name
ORDER BY delivered_orders DESC
LIMIT 10;

