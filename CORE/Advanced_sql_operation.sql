-- Libraries--
SELECT * FROM books
SELECT * FROM branch
SELECT * FROM employees
SELECT * FROM issued_status
SELECT * FROM members
SELECT * FROM return_status

--Identify Members with Overdue Books
--Write a query to identify members who have overdue books (assume a 30-day return period).
-- Display the member's_id, member's name, book title, issue date, and days overdue.


CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$


-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';
SELECT * FROM return_status

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');

-- calling function 
CALL add_return_records('RS148', 'IS140', 'Good');

------------

--Branch Performance Report
--Create a query that generates a performance report for each branch, 
--showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

SELECT * FROM books
SELECT * FROM branch
SELECT * FROM employees
SELECT * FROM issued_status
SELECT * FROM members
SELECT * FROM return_status

CREATE TABLE branch_reports AS
SELECT 
    e.branch_id,
    br.manager_id, 
    COUNT(i.issued_id) AS total_issued_books,
    COUNT(r.return_id) AS returned_items,
    SUM(b.rental_price) AS price
FROM issued_status i
LEFT JOIN employees e ON i.issued_emp_id = e.emp_id
LEFT JOIN return_status r ON i.issued_id = r.issued_id
LEFT JOIN books b ON i.issued_book_isbn = b.isbn
JOIN branch br ON e.branch_id = br.branch_id
GROUP BY e.branch_id, br.manager_id;

SELECT * FROM branch_reports;
-----------------------------

--Create a Table of Active Members
--Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
--containing members who have issued at least one book in the last 2 months.
SELECT * FROM books
SELECT * FROM branch
SELECT * FROM employees
SELECT * FROM issued_status
SELECT * FROM members
SELECT * FROM return_status


CREATE TABLE activee_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    )
;

SELECT * FROM activee_members;

-----------------------------------
--Find Employees with the Most Book Issues Processed
--Write a query to find the top 3 employees who have processed the most book issues. 
--Display the employee name, number of books processed, and their branch.

SELECT * FROM books
SELECT * FROM branch
SELECT * FROM employees
SELECT * FROM issued_status
SELECT * FROM members
SELECT * FROM return_status

SELECT
    i.issued_emp_id,
    e.emp_name,
    b.branch_address,
    COUNT(*) as count_of_issues
from issued_status i
 JOIN employees e ON i.issued_emp_id = e.emp_id
 JOIN branch b ON e.branch_id = b.branch_id
GROUP BY i.issued_emp_id , e.emp_name , b.branch_address
ORDER BY 4 DESC
LIMIT 3 ; 

-----------------------
--Identify Members Issuing High-Risk Books
--Write a query to identify members who have issued books more than twice with the status "damaged" in the books table.
--Display the member name, book title, and the number of times they've issued damaged books.
SELECT * FROM books
SELECT * FROM branch
SELECT * FROM employees
SELECT * FROM issued_status
SELECT * FROM members
SELECT * FROM return_status

SELECT
    m.member_name,
    i.issued_book_name,
    COUNT(m.member_name) as num_of_issuing_books,
    r.book_quality
from return_status r
JOIN issued_status i on r.issued_id = i.issued_id
JOIN members m on i.issued_member_id = m.member_id
WHERE r.book_quality = 'Damaged'
GROUP BY m.member_name ,i.issued_book_name, r.book_quality

-------------------
/*
: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system.
 Description: Write a stored procedure that updates the status of a book in the library based on its issuance.
  The procedure should function as follows:
   The stored procedure should take the book_id as an input parameter.
   The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, 
   and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), 
   the procedure should return an error message indicating that the book is currently not available.
*/
SELECT * FROM books
SELECT * FROM branch
SELECT * FROM employees
SELECT * FROM issued_status
SELECT * FROM members
SELECT * FROM return_status


CREATE OR REPLACE PROCEDURE issue_book(
    p_issued_id VARCHAR(10),
    p_issued_member_id VARCHAR(30),
    p_issued_book_isbn VARCHAR(30),
    p_issued_emp_id VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR(10);
BEGIN
    -- Safely check if book exists and get status
    SELECT status
    INTO v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN
        -- Insert issue record
        INSERT INTO issued_status(
            issued_id,
            issued_member_id,
            issued_date,
            issued_book_isbn,
            issued_emp_id
        )
        VALUES (
            p_issued_id,
            p_issued_member_id,
            CURRENT_DATE,
            p_issued_book_isbn,
            p_issued_emp_id
        );

        -- Update book status to 'no'
        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        RAISE NOTICE '✅ Book issued successfully for ISBN: %', p_issued_book_isbn;

    ELSE
        RAISE NOTICE '❌ Book unavailable. ISBN: %', p_issued_book_isbn;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE '❌ No book found with ISBN: %', p_issued_book_isbn;
END;
$$;


CALL issue_book('IS158', 'C108', '978-0-14-118776-1', 'E104'); -- should succeed
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104'); -- should show unavailable


-------------------------------------
