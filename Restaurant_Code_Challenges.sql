-- Create invitations for a party
---------------------------------
SELECT FirstName, LastName, Email
FROM Customers
ORDER BY LastName


-- Create a table to store information
---------------------------------
CREATE TABLE Reservations2
( CustomerID INT , PartySize INT);


-- Print a menu
---------------------------------
SELECT *
FROM Dishes
ORDER BY Price;

SELECT *
FROM Dishes
WHERE type="Appetizer" or type="Beverage"
ORDER BY type;

SELECT *
FROM Dishes
WHERE type!="Beverage"
ORDER BY type;


-- Sign a customer up for your loyalty program
---------------------------------
INSERT INTO Customers
    (FirstName, LastName, Email, Address, City, State, Phone, Birthday)
    VALUES
    ("Emmanuel", "Cortes", "asdf@gmail.com", "123 Fake St.", 
        "Concord", "CA", "925-555-555", "1996-01-01");


-- Update a customer's personal information
---------------------------------
UPDATE Customers
SET Address = "73 Pine St.", 
    City = "New York", 
    State = "NY"
WHERE CustomerID = 26;


-- Remove  a customer's record
---------------------------------
DELETE FROM Customers
WHERE CustomerID=4;


-- Log customer responses
---------------------------------
INSERT INTO Reservations2 
    (PartySize, CustomerID)
    VALUES
    (4, (SELECT CustomerID FROM Customers WHERE Email="atapley2j@kinetecoinc.com"


-- Look up reservations
---------------------------------
SELECT C.FirstName, C.LastName, R.Date, R.PartySize
FROM Customers AS C
    JOIN Reservations AS R
        ON C.CustomerID=R.CustomerID
WHERE LastName LIKE 'STE%' AND LastName LIKE '%N'


-- Take a reservation
---------------------------------
-- Customer does not exist therefore add first and get customerID
INSERT INTO Customers
(FirstName, LastName, Email, Phone)
VALUES
("Sam", "McAdams", "smac@rouxacademy.com", "555-555-5555")

INSERT INTO Reservations 
    (ReservationID, -- Table does not autoincrement new unique ID
    CustomerID, 
    Date, 
    PartySize)
    VALUES
    ((SELECT MAX(ReservationID) FROM Reservations) + 1,
    (SELECT CustomerID FROM Customers WHERE Email="smac@rouxacademy.com"), 
    "2020-07-14 18:00", 
    5)


-- Take a delivery order
---------------------------------
-- Add order record; CustomerID = 70
INSERT INTO Orders
(CustomerID, OrderDate)
VALUES
((SELECT CustomerID FROM Customers WHERE Address="6939 Elka Place" AND LastName="Hundey"),
(SELECT strftime('%Y-%m-%d %H:%M:%S', datetime('now'))))

-- Add dishes to OrdersDishes for the new order;
INSERT INTO OrdersDishes (OrderID, DishID)
SELECT 
    (SELECT MAX(OrderID) FROM Orders WHERE CustomerID=70) AS OrderID, 
    DishID
FROM Dishes 
WHERE Name IN ("House Salad", "Mini Cheeseburgers", "Tropical Blue Smoothie")

-- Get order total
SELECT SUM(Price) AS TOTAL
FROM Dishes as D
    JOIN OrdersDishes AS OD
        ON D.DishID = OD.DishID
WHERE OD.OrderID = (SELECT MAX(OrderID) FROM Orders WHERE CustomerID=70)


-- Track your customer's favorite dishes
---------------------------------
UPDATE Customers
SET FavoriteDish=(SELECT DishID 
                    FROM Dishes
                    WHERE name = "Quinoa Salmon Salad")
WHERE CustomerID=(SELECT CustomerID 
                    FROM Customers 
                    WHERE FirstName = "Cleo" AND LastName= "Goldwater")


-- Prepare a report of your top five customers
--------------------------------- 
SELECT COUNT(O.OrderID) AS OrderCount, C.FirstName, C.LastName, C.Email
FROM Orders AS O 
    JOIN Customers AS C
        ON C.CustomerID = O.CustomerID
GROUP BY O.CustomerID
ORDER BY OrderCount DESC
LIMIT 5