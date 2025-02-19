Create table Books(
	Book_ID	Serial 	Primary key,
	Title	Varchar(1000),
	Author	Varchar(100),
	Genre	Varchar(100),	
	Published_Year	INT,
	Price	Numeric(6,2),	
	Stock	INT
);
Copy Books (Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
From 'C:/Users/ZEESHAN ALI/OneDrive/Desktop/SQL/Project 1/Books.csv'
CSV Header;

Create table Customers(
	Customer_ID	Serial	Primary key,
	Name	Varchar(100),
	Email	Varchar(100),	
	Phone	INT,
	City	Varchar(100),
	Country	Varchar(100)	
);
Copy Customers (Customer_ID,Name,Email,Phone,City,Country)
From 'C:\Users\ZEESHAN ALI\OneDrive\Desktop\SQL\Project 1\Customers.csv'
CSV Header;

Create table Orders(
	Order_ID	Serial	Primary key,
	Customer_ID	INT	References Customers (Customer_ID),
	Book_ID	INT	References Books (Book_ID),
	Order_Date Date,
	Quantity Numeric(4),	
	Total_Amount Numeric(7,2)
);
Copy Orders (Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
From 'C:\Users\ZEESHAN ALI\OneDrive\Desktop\SQL\Project 1\Orders.csv'
CSV Header;

Select * from Customers;
Select * from Books;
Select * from Orders;

--1) Retrieve all books in the "Fiction" genre 
Select * from Books where genre='Fiction';
--2) Find books published after the year 1950 
Select * from Books where Published_Year>1950 order by Published_Year ASC;
--3) List all customers from Canada 
Select * from Customers where Country='Canada' order by Customer_ID ASC;	
--4) Show orders placed in November 2023 
Select * from orders where Order_Date BETWEEN '2023-11-01' AND '2023-11-30' order by Order_Date ASC;
--5) Retrieve the total stock of books available  
Select * from books where stock>0 order by Stock asc;
Select sum(stock) as total_stock from books;
--6) Find the details of the most expensive book 
Select * from books order by price desc;
--7) Show all customers who ordered more than 1 quantity of a book 
Select * from orders where quantity>1 order by quantity ASC;
--8) Retrieve all orders where the total amount exceeds $20  
Select * from orders where total_amount>20 order by total_amount ASC;
--9) List all genres available in the Books table 
Select count(Distinct genre) as total_genres from books;
Select distinct genre from books;
--10) Find the book with the lowest stock  
Select * from books order by stock Asc;
--11) Calculate the total revenue generated from all orders 
Select sum(total_amount) as total_revenue from orders;
--12) Retrieve the total number of books sold for each genre  
Select b.genre,sum(o.quantity) 
from orders o 
join books b on o.book_id=b.book_id
group by b.genre;
-- to check the stock of each books
Select genre, sum(stock) from books group by genre order by sum(stock) desc;
--13) Find the average price of books in the "Fantasy" genre 
Select avg(price) as average_price from books where genre='Fantasy';
--14) List customers who have placed at least 2 orders 
Select C.name,O.quantity
from orders o
join customers C on c.customer_id=o.customer_id
where o.quantity>=2 order by o.quantity Asc;
--Use of having
Select customer_id, count(order_id) as total_orders
from orders
group by customer_id
having count(order_id)>=2 order by customer_id ASC;
-- we want to see the name of customer as well
Select c.customer_id,c.name, count(o.order_id) as total_orders
from orders o
join customers c on c.customer_id=o.customer_id
group by c.customer_id,c.name
having count(o.order_id)>=2 order by c.customer_id ASC;
--15) Find the most frequently ordered book 
Select b.title,count(o.order_id)
from books b
join orders o on b.book_id=o.book_id
group by b.title
order by count(o.order_id) desc ;
--16) Show the top 3 most expensive books of the 'Fantasy' genre 
Select title,price as  expensice_books from books where genre='Fantasy' order by price desc limit 3;
--17) Retrieve the total quantity of books sold by each author
Select b.author,sum(o.quantity)
from orders o
join books b on b.book_id=o.book_id
group by b.author;
--18) List the cities where customers who spent over $30 are located 
Select distinct(c.city),o.total_amount
from customers c
join orders o on c.customer_id=o.customer_id
where o.total_amount>30 order by o.total_amount Asc;
--19) Find the customer who spent the most on orders  
Select c.name, sum(o.total_amount) 
from orders o
join customers c on c.customer_id=o.customer_id
group by c.name
order by sum(o.total_amount) desc limit 5;
--20) Calculate the stock remaining after fulfilling all orders  
Select b.title,b.stock,coalesce(sum(o.quantity),0) as order_quantity, b.stock-coalesce(sum(o.quantity),0) as remaing
from books b
left join orders o on b.book_id=o.book_id
Group by b.title,b.stock;
