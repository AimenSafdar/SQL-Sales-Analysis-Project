
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- CREATE TABLES


CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100),
    price NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);



-- INSERT DATA INTO CUSTOMERS


INSERT INTO customers (customer_name, city, country) VALUES
('Ali Khan','Lahore','Pakistan'),
('Sara Ahmed','Karachi','Pakistan'),
('John Smith','London','UK'),
('Emma Brown','Manchester','UK'),
('Ahmed Raza','Islamabad','Pakistan'),
('Sophia Lee','New York','USA');



-- INSERT DATA INTO PRODUCTS


INSERT INTO products (product_name, category, price) VALUES
('Laptop','Electronics',900),
('Smartphone','Electronics',600),
('Headphones','Electronics',120),
('Office Chair','Furniture',200),
('Desk Lamp','Furniture',50),
('Tablet','Electronics',400);

-- INSERT DATA INTO ORDERs

INSERT INTO orders (customer_id, order_date) VALUES
(1,'2024-01-10'),
(2,'2024-01-12'),
(3,'2024-02-05'),
(4,'2024-02-20'),
(5,'2024-03-01'),
(6,'2024-03-10'),
(1,'2024-03-15'),
(2,'2024-03-18');


-- INSERT DATA INTO ORDER ITEMS


INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1,1,1),
(1,3,2),
(2,2,1),
(3,1,1),
(3,4,1),
(4,5,3),
(5,2,2),
(6,6,1),
(7,3,1),
(8,4,2);

SELECT * FROM customers;
SELECT * FROM products;

#total revenue of the business
SELECT SUM(p.price * oi.quantity) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id;

##total number of orders

SELECT COUNT(*) AS total_orders
FROM orders;

##top selling products

SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

##revenue by product
SELECT 
    p.product_name,
    SUM(p.price * oi.quantity) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;

##valuable customers

SELECT 
    c.customer_name,
    SUM(p.price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
JOIN order_items oi 
ON o.order_id = oi.order_id
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

##revenue by country
SELECT 
    c.country,
    SUM(p.price * oi.quantity) AS revenue
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
JOIN order_items oi 
ON o.order_id = oi.order_id
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY c.country
ORDER BY revenue DESC;

##monthly sales trend

SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(p.price * oi.quantity) AS monthly_revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY month
ORDER BY month;

##rank products by revenue
SELECT 
    p.product_name,
    SUM(p.price * oi.quantity) AS revenue,
    RANK() OVER (ORDER BY SUM(p.price * oi.quantity) DESC) AS rank
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name;