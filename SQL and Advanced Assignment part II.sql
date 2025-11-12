/* ============================================================
   ECommerceDB Assignment — Questions 6 to 9
   Author: [Your Name]
   Description: Full database creation, data insertion,
                and analytical queries using SQL.
============================================================ */

-- ------------------------------------------------------------
-- QUESTION 6: Create Database and Tables
-- ------------------------------------------------------------

DROP DATABASE IF EXISTS ECommerceDB;
CREATE DATABASE ECommerceDB;
USE ECommerceDB;

-- Create Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    CategoryID INT,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- ------------------------------------------------------------
-- Insert data into Categories
-- ------------------------------------------------------------

INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Home Goods'),
(4, 'Apparel');

-- ------------------------------------------------------------
-- Insert data into Products
-- ------------------------------------------------------------

INSERT INTO Products (ProductID, ProductName, CategoryID, Price, StockQuantity) VALUES
(101, 'Laptop Pro', 1, 1200.00, 50),
(102, 'SQL Handbook', 2, 45.50, 200),
(103, 'Smart Speaker', 1, 99.99, 150),
(104, 'Coffee Maker', 3, 75.00, 80),
(105, 'Novel: The Great SQL', 2, 25.00, 120),
(106, 'Wireless Earbuds', 1, 150.00, 100),
(107, 'Blender X', 3, 120.00, 60),
(108, 'T-Shirt Casual', 4, 20.00, 300);

-- ------------------------------------------------------------
-- Insert data into Customers
-- ------------------------------------------------------------

INSERT INTO Customers (CustomerID, CustomerName, Email, JoinDate) VALUES
(1, 'Alice Wonderland', 'alice@example.com', '2023-01-10'),
(2, 'Bob the Builder', 'bob@example.com', '2022-11-25'),
(3, 'Charlie Chaplin', 'charlie@example.com', '2023-03-01'),
(4, 'Diana Prince', 'diana@example.com', '2021-04-26');

-- ------------------------------------------------------------
-- Insert data into Orders
-- ------------------------------------------------------------

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(1001, 1, '2023-04-26', 1245.50),
(1002, 2, '2023-10-12', 99.99),
(1003, 1, '2023-07-01', 145.00),
(1004, 3, '2023-01-14', 150.00),
(1005, 2, '2023-09-24', 120.00),
(1006, 1, '2023-06-19', 20.00);

-- ------------------------------------------------------------
-- QUESTION 7: Report — Customers with Total Orders
-- ------------------------------------------------------------

SELECT 
    c.CustomerName,
    c.Email,
    COUNT(o.OrderID) AS TotalNumberOfOrders
FROM 
    Customers c
LEFT JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID, c.CustomerName, c.Email
ORDER BY 
    c.CustomerName;

-- ------------------------------------------------------------
-- QUESTION 8: Product Info with Category
-- ------------------------------------------------------------

SELECT 
    p.ProductName,
    p.Price,
    p.StockQuantity,
    c.CategoryName
FROM 
    Products p
INNER JOIN 
    Categories c ON p.CategoryID = c.CategoryID
ORDER BY 
    c.CategoryName ASC, 
    p.ProductName ASC;

-- ------------------------------------------------------------
-- QUESTION 9: Top 2 Most Expensive Products per Category
-- ------------------------------------------------------------

WITH RankedProducts AS (
    SELECT 
        c.CategoryName,
        p.ProductName,
        p.Price,
        ROW_NUMBER() OVER (
            PARTITION BY c.CategoryName 
            ORDER BY p.Price DESC
        ) AS rank_no
    FROM 
        Products p
    INNER JOIN 
        Categories c ON p.CategoryID = c.CategoryID
)
SELECT 
    CategoryName,
    ProductName,
    Price
FROM 
    RankedProducts
WHERE 
    rank_no <= 2
ORDER BY 
    CategoryName ASC, 
    Price DESC;

-- Question 10: Sakila Video Rentals Data Analysis
-- You are hired as a data analyst by Sakila Video Rentals, a global movie rental company.
-- Using the Sakila database, answer the following business questions to support key strategic initiatives.

-- 1️⃣ Identify the top 5 customers based on the total amount they’ve spent.
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    c.email,
    SUM(p.amount) AS TotalAmountSpent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY TotalAmountSpent DESC
LIMIT 5;

-- 2️⃣ Which 3 movie categories have the highest rental counts?
SELECT 
    cat.name AS CategoryName,
    COUNT(r.rental_id) AS RentalCount
FROM category cat
JOIN film_category fc ON cat.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY cat.category_id
ORDER BY RentalCount DESC
LIMIT 3;

-- 3️⃣ Calculate how many films are available at each store and how many of those have never been rented.
SELECT 
    s.store_id,
    COUNT(i.inventory_id) AS TotalFilms,
    SUM(CASE WHEN r.rental_id IS NULL THEN 1 ELSE 0 END) AS NeverRentedFilms
FROM store s
JOIN inventory i ON s.store_id = i.store_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY s.store_id;

-- 4️⃣ Show the total revenue per month for the year 2023.
SELECT 
    DATE_FORMAT(p.payment_date, '%Y-%m') AS Month,
    SUM(p.amount) AS TotalRevenue
FROM payment p
WHERE YEAR(p.payment_date) = 2023
GROUP BY Month
ORDER BY Month;


-- ============================================================
-- END OF ASSIGNMENT
-- ============================================================
