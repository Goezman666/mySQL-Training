CREATE SCHEMA `gadgetglobe` ;

USE gadgetglobe;
SET FOREIGN_KEY_CHECKS = 0;


-- 1. CUSTOMER TABLE
CREATE TABLE Customers (
	customer_id INT AUTO_INCREMENT PRIMARY KEY, -- AUTO INCREMENT FOR MYSQL
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    registration_date DATE NOT NULL,
    city VARCHAR(50),
    country VARCHAR(50)
);

-- Sample data for Customers
INSERT INTO Customers (first_name, last_name, email, registration_date, city, country) VALUES
('Alice', 'Smith', 'alice.smith@example.com', '2024-06-01', 'New York', 'USA'),
('Bob', 'Johnson', 'bob.johnson@example.com', '2024-05-15', 'London', 'UK'),
('Charlie', 'Brown', 'charlie.b@example.com', '2023-11-20', 'Paris', 'France'),
('Diana', 'Miller', 'diana.m@example.com', '2024-06-10', 'Berlin', 'Germany'),
('Eve', 'Davis', 'eve.d@example.com', '2023-01-05', 'Tokyo', 'Japan'),
('Frank', 'White', 'frank.w@example.com', '2024-03-22', 'Sydney', 'Australia'),
('Grace', 'Black', 'grace.b@example.com', '2024-06-15', 'Rome', 'Italy'),
('Henry', 'Green', 'henry.g@example.com', '2023-07-30', 'Madrid', 'Spain'),
('Ivy', 'King', 'ivy.k@example.com', '2024-04-01', 'Toronto', 'Canada'),
('Jack', 'Lee', 'jack.l@example.com', '2024-06-05', 'Seoul', 'South Korea');

-- 2. Product Table
CREATE TABLE Products (
	product_id INT auto_increment primary key,
	product_name VARCHAR(100) NOT NULL,
	category VARCHAR(50) NOT NULL,
	price DECIMAL(10, 2) NOT NULL,
	stock_quantity int NOT NULL
);

-- sample data for products
INSERT INTO Products (product_name, category, price, stock_quantity) VALUES
('Smartphone X', 'Smartphones', 899.99, 120),
('Laptop Pro 15', 'Laptops', 1499.00, 75),
('Wireless Earbuds Z', 'Accessories', 129.50, 300),
('Smartwatch V2', 'Wearables', 299.00, 150),
('Portable Speaker S', 'Accessories', 79.99, 250),
('Gaming Laptop 17', 'Laptops', 1999.99, 40),
('Drone Explorer', 'Accessories', 450.00, 30),
('Fitness Tracker Plus', 'Wearables', 99.00, 200),
('Tablet Mini', 'Tablets', 350.00, 90),
('External SSD 1TB', 'Accessories', 110.00, 180),
('VR Headset Pro', 'Accessories', 699.00, 5), -- Low stock
('Gaming Mouse G1', 'Accessories', 55.00, 100),
('Mechanical Keyboard', 'Accessories', 90.00, 45);

-- 3. Order Table
CREATE TABLE Orders (
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    CONSTRAINT fk_customer
		FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

-- Sample data for Orders
INSERT INTO Orders (customer_id, order_date, total_amount, status) VALUES
(1, '2024-06-02', 1029.49, 'Completed'), -- Alice
(2, '2024-05-16', 1499.00, 'Completed'), -- Bob
(3, '2023-12-01', 500.00, 'Completed'), -- Charlie
(1, '2024-06-12', 250.00, 'Pending'),   -- Alice again
(4, '2024-06-11', 899.99, 'Completed'), -- Diana
(5, '2023-01-10', 398.00, 'Completed'), -- Eve
(3, '2023-12-25', 1200.00, 'Completed'), -- Charlie, high value
(6, '2024-03-25', 189.99, 'Completed'), -- Frank
(7, '2024-06-16', 79.99, 'Pending'),    -- Grace
(8, '2023-08-01', 99.00, 'Completed'), -- Henry
(9, '2024-04-05', 330.00, 'Completed'), -- Ivy
(1, '2024-01-15', 75.00, 'Completed'),   -- Alice again, different year
(5, '2023-02-20', 1500.00, 'Completed'), -- Eve, high value
(10, '2024-06-06', 149.00, 'Completed'); -- Jack

-- 4. Order_items Table
CREATE TABLE Order_Items (
	order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    item_price DECIMAL(10, 2) NOT NULL, -- price at the time order
    CONSTRAINT fk_order
		FOREIGN KEY (order_id)
        REFERENCES Orders (order_id),
	CONSTRAINT fk_product
		FOREIGN KEY (product_id)
        REFERENCES Products (product_id)
);

-- Sample data for Order_Items
INSERT INTO Order_Items (order_id, product_id, quantity, item_price) VALUES
-- Order 1 (Alice)
(1, 1, 1, 899.99), -- Smartphone X
(1, 3, 1, 129.50), -- Wireless Earbuds Z
-- Order 2 (Bob)
(2, 2, 1, 1499.00), -- Laptop Pro 15
-- Order 3 (Charlie)
(3, 4, 1, 299.00), -- Smartwatch V2
(3, 5, 2, 79.99),  -- Portable Speaker S (2 items)
-- Order 4 (Alice)
(4, 1, 1, 899.99), -- This price is actually too high for total_amount 250 in Orders. This is a potential data quality issue for Task 6! Let's correct total amount in orders table later
-- Order 5 (Diana)
(5, 1, 1, 899.99), -- Smartphone X
-- Order 6 (Eve)
(6, 8, 4, 99.00),  -- Fitness Tracker Plus (4 items)
-- Order 7 (Charlie) - high value
(7, 2, 1, 1499.00), -- Laptop Pro 15
(7, 6, 1, 1999.99), -- Gaming Laptop 17
(7, 4, 2, 299.00),
-- Order 8 (Frank)
(8, 3, 1, 129.50), -- Wireless Earbuds Z
(8, 5, 1, 79.99),  -- Portable Speaker S
-- Order 9 (Grace)
(9, 5, 1, 79.99),  -- Portable Speaker S
-- Order 10 (Henry)
(10, 8, 1, 99.00), -- Fitness Tracker Plus
-- Order 11 (Ivy)
(11, 9, 1, 350.00), -- Tablet Mini
-- Order 12 (Alice, 2024-01-15)
(12, 5, 1, 79.99), -- Portable Speaker S
-- Order 13 (Eve, high value)
(13, 6, 1, 1999.99), -- Gaming Laptop 17
(13, 1, 1, 899.99),
-- Order 14 (Jack)
(14, 10, 1, 110.00); -- External SSD 1TB

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Correction: Let's adjust total_amount for order 4 to reflect actual item prices,
-- as it was initially set incorrectly in the sample data.
UPDATE Orders
SET total_amount = (SELECT SUM(quantity * item_price) FROM Order_Items WHERE order_id = 4)
WHERE order_id = 4;

-- You can also add more items to simulate high sales for some products if needed for Task 3
-- For example, let's make Smartphone X and Wireless Earbuds Z sell more for testing

INSERT INTO Order_Items (order_id, product_id, quantity, item_price) VALUES
(1, 1, 5, 899.99), -- Added 5 more Smartphone X to order 1 (for simulation)
(3, 3, 10, 129.50), -- Added 10 more Wireless Earbuds Z to order 3
(5, 1, 3, 899.99), -- Added 3 more Smartphone X to order 5
(7, 3, 7, 129.50), -- Added 7 more Wireless Earbuds Z to order 7
(12, 1, 2, 899.99); -- Added 2 more Smartphone X to order 12

    
      