-- Retrieve All Books in a Specific Category:
SELECT * FROM books
WHERE category = 'Horror'

------------

--Task 8: Find Total Rental Income by Category:
SELECT
    b.category,
    COUNT(b.category) as count_of_category,
    SUM(b.rental_price) as total_rental_price
from books b
GROUP BY b.category

--------------
--List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE reg_date BETWEEN DATE '2021-06-01' AND DATE '2021-12-31';

----------
--List Employees with Their Branch Manager's Name and their branch details:

SELECT
  e.emp_name AS employee_name,
  e.position,
  e.salary,
  b.manager_id,
  em.emp_name AS manager_name,
  b.branch_address,
  b.contact_no
FROM employees e
JOIN branch b ON e.branch_id = b.branch_id
JOIN employees em ON b.manager_id = em.emp_id;

-------------
-- Create a Table of Books with Rental Price Above a Certain Threshold:
SELECT * FROM books 
WHERE rental_price > 5 

------------
--Retrieve the List of Books Not Yet Returned
SELECT
    r.return_id,
    r.issued_id,
    i.issued_book_name AS book_name,
    r.return_date,
    b.isbn,
    r.book_quality
FROM return_status r
JOIN issued_status i ON r.issued_id = i.issued_id
LEFT JOIN books b on  i.issued_book_name  = b.book_title
WHERE r.return_date <= DATE '2024-05-01';

---------