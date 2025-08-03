
# 📚 Library Management System (SQL Project)

This project simulates a **Library Management System** using PostgreSQL. It demonstrates the design and interaction of relational tables, data integrity with constraints, stored procedures, and business logic to manage book issuance and returns.

---

## 📌 Project Overview

This SQL project includes:
- Issuing and returning books
- Managing book availability
- Tracking members and employees
- Generating analytical reports using SQL queries
- Automating logic using PL/pgSQL stored procedures

---

## 🗃️ Database Schema

### ✅ Tables:

- `books`: Stores book details like ISBN, title, category, status, etc.
- `members`: Library users (borrowers)
- `employees`: Staff who issue books
- `branch`: Library branches
- `issued_status`: Tracks issued books
- `return_status`: Tracks returned books

---

## 🔧 Key Features

### 📦 Book Issuance Procedure:
Automatically:
- Checks if a book is available
- Issues the book
- Updates book availability
- Generates a unique `issued_id`

```sql
CALL issue_book('C108', '978-0-553-29698-2', 'E104');
```

### 📦 Return Book Procedure:
Automatically:
- Inserts return record
- Updates book availability back to `'yes'`
- Raises a thank you message

```sql
CALL update_return_status('RS101', 'IS155', 'Good');
```

---

## 📊 Reports & Queries

- **Top 3 employees by issued books**
- **Branch-level revenue and returns**
- **Active members in the last 60 days**
- **Damaged book tracking by member**
- **Members who issued the most books**

> Every query in the project is optimized and uses `JOIN`, `GROUP BY`, `ORDER BY`, and conditional logic.

---

## 🚀 Getting Started

1. Use PostgreSQL (e.g., via pgAdmin or VS Code SQL extensions)
2. Create all tables (DDL scripts provided)
3. Run the insert sample data scripts
4. Create the stored procedures
5. Execute sample `CALL` and `SELECT` statements

---

## 📂 Folder Structure

```
PROJECT_SQL/
│
├── create_tables.sql
├── insert_data.sql
├── procedures.sql
├── queries.sql
├── README.md
```

---

## 🧠 Skills Used

- PostgreSQL
- SQL Joins and Aggregations
- PL/pgSQL Procedures
- Data Modeling
- Relational Integrity
- Git & GitHub

---

## 👨‍💻 Author

**Omar Mostafa Khalaf Faragallah**  
Student – Al-Azhar University  
[LinkedIn](#) | [GitHub](#)

---

## 📌 License

This project is open-source and available under the [MIT License](LICENSE).
