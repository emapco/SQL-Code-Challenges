-- Check book availability
---------------------------------
-- number of copys of book
SELECT COUNT(*) FROM Books WHERE Title='Dracula'

-- number of copys currently loaned
SELECT COUNT(*)
FROM Loans as L
    JOIN Books as B
        ON L.BookID = B.BookID
WHERE Title='Dracula'
    AND ReturnedDate IS NULL

-- number of copys available
SELECT 
    (SELECT COUNT(*) FROM Books WHERE Title='Dracula')
    -
    (SELECT COUNT(*)
    FROM Loans as L
        JOIN Books as B
            ON L.BookID = B.BookID
    WHERE Title='Dracula'
        AND ReturnedDate IS NULL)
AS BooksAvailable;


-- Add new books to the library
---------------------------------
INSERT INTO Books
    (Title, Author, Published, Barcode)
    VALUES
    ('Dracula', 'Bram Stoker', 1897, 4819277482), 
    ('Gulliver''s Travels', 'Jonathan Swift', 1729, 4899254401);


-- Check out books
---------------------------------
INSERT INTO Loans (PatronID, BookID, LoanDate, DueDate)
SELECT P.PatronID, B.BookID, '2020-08-25' AS LoanDate, '2020-09-08' AS DueDate
FROM Patrons AS P
    CROSS JOIN Books AS B
WHERE P.Email='jvaan@wisdompets.com'
    AND Barcode IN (2855934983, 4043822646)


-- Check for books due back
---------------------------------
SELECT L.DueDate, B.Title, P.FirstName, P.LastName, P.Email
FROM Loans AS L
    JOIN Patrons AS P
        ON L.PatronID = P.PatronID
    JOIN Books AS B
        ON L.BookID = B.BookID
WHERE ReturnedDate IS NULL  
    AND DueDate='2020-07-13'


-- Return books to the library
---------------------------------
-- Books that were returned barcodes: 6435968624, 5677520613, 8730298424
UPDATE Loans
SET ReturnedDate='2020-07-05'
WHERE BookID IN (SELECT BookID
                    FROM Books
                    WHERE Barcode IN (6435968624, 5677520613, 8730298424))
    AND ReturnedDate IS NULL


-- Encourage patrons to check out books
---------------------------------
SELECT COUNT(P.PatronId) AS BooksCheckedOut, P.FirstName, P.LastName, P.Email
FROM Patrons AS P
    JOIN Loans AS L
        ON P.PatronID = L.PatronID
GROUP BY P.PatronID
ORDER BY BooksCheckedOut
LIMIT 10


-- Find books to feature for an event
---------------------------------
-- subquery returns the BookID for all books currently checked out
SELECT Title, BookID, Author, Published
FROM Books
WHERE Published BETWEEN 1890 AND 1899 
    AND BookID NOT IN
        (SELECT L.BookID 
            FROM Loans AS L
                JOIN Books AS B
                    ON L.BookID = B.BookID
            WHERE ReturnedDate IS NULL)
ORDER BY Title;


-- Book statistics
---------------------------------
-- report showing how many books were published each year (desc year)
SELECT COUNT(DISTINCT(TITLE)) AS BooksPublished, Published
FROM Books
GROUP BY Published
ORDER BY BooksPublished DESC, Published ASC;

-- five most popular books checked out
SELECT COUNT(Title) AS TimesCheckedOut, B.Title
FROM Books AS B
    JOIN Loans AS L
        ON B.BookID = L.BookID
GROUP BY B.Title
ORDER BY TimesCheckedOut DESC
LIMIT 5