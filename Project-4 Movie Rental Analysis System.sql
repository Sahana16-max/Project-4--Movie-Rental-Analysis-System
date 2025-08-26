-- create a database named MovieRental
CREATE DATABASE MovieRental;
USE MovieRental;

-- CREATE TABLE rental_data 
CREATE TABLE rental_data (
MOVIE_ID integer,
CUSTOMER_ID integer,
GENRE varchar(50),
RENTAL_DATE date,
RETURN_DATE date,
RENTAL_FEE numeric(5,2)
);

-- Data Entry
-- Insert 10–15 sample rental records
INSERT INTO rental_data (MOVIE_ID, CUSTOMER_ID, GENRE, RENTAL_DATE, RETURN_DATE, RENTAL_FEE)
VALUES
(1, 101, 'Action', '2025-06-01', '2025-06-03', 4.99),
(2, 102, 'Comedy', '2025-06-02', '2025-06-04', 3.99),
(3, 103, 'Drama', '2025-06-03', '2025-06-06', 4.99),
(4, 104, 'Action', '2025-06-04', '2025-06-07', 5.99),
(5, 105, 'Sci-Fi', '2025-06-05', '2025-06-08', 5.99),
(1, 106, 'Action', '2025-06-06', '2025-06-09', 4.99),
(6, 107, 'Comedy', '2025-06-07', '2025-06-10', 3.99),
(7, 108, 'Drama', '2025-06-08', '2025-06-11', 4.99),
(8, 109, 'Sci-Fi', '2025-06-09', '2025-06-12', 5.99),
(9, 110, 'Action', '2025-06-10', '2025-06-13', 5.99),
(10, 111, 'Comedy', '2025-06-11', '2025-06-14', 3.99),
(11, 112, 'Drama', '2025-06-12', '2025-06-15', 4.99),
(12, 113, 'Action', '2025-06-13', '2025-06-16', 5.99),
(13, 114, 'Sci-Fi', '2025-06-14', '2025-06-17', 5.99),
(14, 115, 'Comedy', '2025-06-15', '2025-06-18', 3.99);

-- OLAP Operations
-- Drill Down: Analyze rentals from genre to individual movie level
SELECT GENRE, MOVIE_ID, COUNT(*) as Rentals, SUM(RENTAL_FEE) as Total_Fee
FROM rental_data
GROUP BY GENRE, MOVIE_ID
ORDER BY GENRE, MOVIE_ID;

-- Rollup: Summarize total rental fees by genre and then overall
SELECT IFNULL(GENRE, 'All Genres') as GENRE, SUM(RENTAL_FEE) as Total_Fee
FROM rental_data
GROUP BY GENRE WITH ROLLUP;

-- Cube: Analyze total rental fees across combinations of genre, rental date, and customer
(SELECT GENRE, RENTAL_DATE, CUSTOMER_ID, SUM(RENTAL_FEE) as Total_Fee
FROM rental_data
GROUP BY GENRE, RENTAL_DATE, CUSTOMER_ID
UNION ALL
SELECT GENRE, RENTAL_DATE, NULL, SUM(RENTAL_FEE) as Total_Fee
FROM rental_data
GROUP BY GENRE, RENTAL_DATE
UNION ALL
SELECT GENRE, NULL, NULL, SUM(RENTAL_FEE) as Total_Fee
FROM rental_data
GROUP BY GENRE
UNION ALL
SELECT NULL, NULL, NULL, SUM(RENTAL_FEE) as Total_Fee
FROM rental_data)
LIMIT 15;

-- Slice: Extract rentals only from the ‘Action’ genre
SELECT *
FROM rental_data
WHERE GENRE = 'Action';

-- Dice: Extract rentals where GENRE = 'Action' or 'Drama' and RENTAL_DATE is in the last 3 months
SELECT *
FROM rental_data
WHERE GENRE IN ('Action', 'Drama')
AND RENTAL_DATE >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

