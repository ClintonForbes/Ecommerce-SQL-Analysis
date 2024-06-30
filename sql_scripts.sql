USE ecommerce_project;

-- Creating the Customers table with essential customer details.
CREATE TABLE Customers (
	CustomerID int AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
);

-- Creating the Products table to store product information.
CREATE TABLE Products (
	ProductID int AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);

-- Creating the Orders table which records transactions between customers and products.
CREATE TABLE  Orders (
	OrderID int AUTO_INCREMENT PRIMARY KEY,
    CustomerID int,
    ProductID int,
    OrderDate date,
    Quantity int,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


-- Inserting sample data into Customers table.
INSERT INTO Customers (FirstName, LastName, Email) VALUES
('John', 'Doe', 'john.doe@example.com'),
('Jane', 'Smith', 'jane.smith@example.com'),
('Alice', 'Johnson', 'alice.johnson@example.com'),
('Bob', 'Williams', 'bob.williams@example.com'),
('Tom', 'Brown', 'tom.brown@example.com'),
('Linda', 'Davis', 'linda.davis@example.com'),
('Nancy', 'Miller', 'nancy.miller@example.com'),
('Karen', 'Wilson', 'karen.wilson@example.com'),
('Steven', 'Moore', 'steven.moore@example.com'),
('Betty', 'Taylor', 'betty.taylor@example.com');


-- Inserting sample data into Products table.
INSERT INTO Products (ProductName, Price) VALUES
('Laptop', 1200.00),
('Smartphone', 800.00),
('Tablet', 450.00),
('Printer', 150.00),
('Mouse', 25.00),
('Keyboard', 75.00),
('Monitor', 300.00),
('USB Cable', 20.00),
('Webcam', 100.00),
('Headphones', 150.00);


-- Inserting sample orders into Orders table, linking customers and products.
INSERT INTO Orders (CustomerID, ProductID, OrderDate, Quantity) VALUES
(1, 1, '2024-06-01', 1),
(2, 2, '2024-06-02', 2),
(3, 3, '2024-06-03', 1),
(4, 4, '2024-06-04', 1),
(5, 5, '2024-06-05', 2),
(6, 6, '2024-06-06', 1),
(7, 7, '2024-06-07', 2),
(8, 8, '2024-06-08', 3),
(9, 9, '2024-06-09', 1),
(10, 10, '2024-06-10', 1),
(1, 2, '2024-06-11', 2),
(2, 3, '2024-06-12', 1),
(3, 4, '2024-06-13', 1),
(4, 5, '2024-06-14', 1),
(5, 1, '2024-06-15', 2);



SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;



-- Calculate the total quantity of each product sold
SELECT Orders.ProductID, ProductName, SUM(Quantity) AS TotalSold
FROM Orders
JOIN Products ON Orders.ProductID = Products.ProductID
GROUP BY ProductID;


-- Find the average order quantity for each customer
SELECT Orders.CustomerID, FirstName, AVG(Quantity) AS AverageQuantity
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY CustomerID
ORDER BY AverageQuantity DESC;


-- Find customers who have ordered more than the average number of products
SELECT FirstName, LastName
FROM Customers
WHERE CustomerID IN (
	SELECT CustomerID
    FROM Orders
    GROUP BY CustomerID
    HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM Orders)
);


-- Rank customers by the total orders placed
SELECT FirstName, LastName, COUNT(OrderID) AS TotalOrders,
       Rank() OVER (ORDER BY COUNT(OrderID) DESC) AS Ranked
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID;


-- Calculate running total of orders over time
SELECT Orderdate, SUM(Quantity) OVER (ORDER BY Orderdate) AS RunningTotal
FROM Orders;

-- Orders without sales
SELECT 
    Orders.OrderID,
    Orders.OrderDate,
    Customers.FirstName,
    Customers.LastName
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
LEFT JOIN Products ON Orders.ProductID = Products.ProductID
WHERE Products.ProductID IS NULL;

