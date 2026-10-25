--Creating Tables

DROP TABLE IF EXISTS Books;
CREATE TABLE IF NOT EXISTS Books
	(Book_ID		INT PRIMARY KEY,
	Title			VARCHAR(100),
	Author			VARCHAR(50),
	Genre			VARCHAR(50),
	Published_Year  INT,
	Price			NUMERIC(10,2),
	Stock			INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE IF NOT EXISTS Customers
	(Customer_ID		INT PRIMARY KEY,
	Name				VARCHAR(50),
	Email				VARCHAR(100),      
	Phone				VARCHAR(15),
	City				VARCHAR(100),				
	Country				VARCHAR(100)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE IF NOT EXISTS Orders
	(Order_ID		INT PRIMARY KEY,     
	Customer_ID		INT REFERENCES Customers(Customer_ID),
	Book_ID			INT REFERENCES Books(Book_ID),
	Order_Date		DATE,
	Quantity		INT,
	Total_Amount	NUMERIC(10,2)
);

SELECT * FROM Books;

SELECT * FROM Customers;

SELECT * FROM Orders;

--Importing Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'C:\Users\sanja\Desktop\Data Analytics Practice File\SQL Practice File\Practice Files SQL Projects\Practice Files SQL Projects\Books.csv'
DELIMITER ','
CSV HEADER;

--Importing Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:\Users\sanja\Desktop\Data Analytics Practice File\SQL Practice File\Practice Files SQL Projects\Practice Files SQL Projects\Customers.csv'
DELIMITER ','
CSV HEADER;

--Importing Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:\Users\sanja\Desktop\Data Analytics Practice File\SQL Practice File\Practice Files SQL Projects\Practice Files SQL Projects\Orders.csv'
DELIMITER ','
CSV HEADER;

--Basic Queries
--1) Retrieve all books in the 'Fiction' genre
SELECT *
FROM Books
WHERE genre='Fiction';

--2) Find books published after the year 1950
SELECT book_id, title, author, published_year
FROM Books
WHERE published_year>1950;

--3) List all customers from the Canada
SELECT customer_id, name, country
FROM customers
WHERE country='Canada';

--4) Show orders placed in November 2023
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the total  stock of books available
SELECT SUM(stock) AS Total_Stock
FROM Books;

--6) Find the details of the most expensive books
SELECT * FROM Books
ORDER BY price DESC
LIMIT 1;

--7) Show all customers who ordered more than 1 quantity of a book

SELECT * FROM orders
WHERE quantity>1;

--8) Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders
WHERE total_amount>20;


--9) List all genres available in the Books table

SELECT DISTINCT genre
FROM Books;

--10) Find the book with the lowest stock
SELECT * FROM Books
ORDER BY stock
LIMIT 11;

--11) Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS Total_Revenue
FROM Orders;

--Advance Queries
--1) Retrieve the total number of books sold for each genre

SELECT B.genre, SUM(O.quantity) AS Total_Book_Sold
FROM Books AS B
JOIN Orders AS O
ON B.book_id=O.book_id
GROUP BY B.genre;

--2) Find the average price of books in the 'Fantasy' genre
SELECT genre, AVG(price) AS Average_Price
FROM Books
WHERE genre='Fantasy'
GROUP BY genre;


--3)List customers who have placed at least 2 orders
SELECT C.customer_id, C.name, COUNT(O.order_id) AS Order_Count
FROM Customers AS C
JOIN Orders AS O
ON C.customer_id=O.customer_id
GROUP BY C.customer_id, C.name
HAVING COUNT(O.order_id)>=2
ORDER BY COUNT(O.order_id) DESC;

--4) Find the most frequently Ordered book
SELECT O.book_id, B.title, B.genre, COUNT(O.order_id) AS Order_Count
FROM Books AS B
JOIN Orders AS O
ON B.book_id=O.book_id
GROUP BY O.book_id, B.title, B.genre
ORDER BY Order_Count DESC

--5) Show the top 3 most expensive books of 'Fantasy' genre
SELECT book_id, title, price
FROM Books
WHERE genre='Fantasy'
ORDER BY price DESC
LIMIT 3;

--6) Retrieve the total quantity of books sold by each author
SELECT B.author, SUM(O.quantity) AS Total_Quantity_Sold
FROM Books AS B
JOIN Orders AS O
ON B.book_id=O.book_id
GROUP BY B.author;

--7) List the cities where customers who spent over $30 are located
SELECT DISTINCT C.city, O.total_amount
FROM Customers AS C
JOIN Orders AS O
ON C.customer_id=O.customer_id
WHERE O.total_amount>30
ORDER BY O.total_amount;

--8) Find the customer who spent the most on orders 
SELECT C.customer_id, C.name AS Customer_Name, SUM(O.total_amount) AS Total_Spent
FROM Customers AS C
JOIN Orders AS O
ON C.customer_id=O.customer_id
GROUP BY C.customer_id, C.name
ORDER BY Total_Spent DESC
LIMIT 1;


--9) Calculate stock remaining after fulfilling all orders
SELECT B.book_id, B.title, B.stock, COALESCE(SUM(O.quantity),0) AS Order_quantity,
	   B.stock-COALESCE(SUM(O.quantity),0) AS Remaining_Stock
FROM Books AS B
LEFT JOIN Orders AS O
ON B.book_id=O.book_id
GROUP BY B.book_id, B.title
ORDER BY B.book_id;














