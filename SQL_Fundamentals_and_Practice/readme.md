# 📚 SQL Fundamentals & Practice Queries

This repository contains a comprehensive set of SQL queries designed to introduce and reinforce fundamental SQL concepts, ranging from basic data manipulation to advanced topics like window functions, CTEs, and stored procedures. Whether you're a beginner looking to grasp SQL basics or an intermediate user wanting to refresh your knowledge, this collection offers practical examples to solidify your understanding.

---

## 🎯 What You'll Find Here

This collection is structured to guide you through various SQL functionalities:

* **Database & Table Management**: Learn how to create databases and tables, and insert data.
* **Data Retrieval (`SELECT`)**: Master `SELECT` statements, including specific column selection, `DISTINCT` values, and basic arithmetic operations.
* **Data Filtering (`WHERE`)**: Understand how to filter data using comparison and logical operators (`AND`, `OR`, `NOT`, `LIKE`).
* **Data Grouping & Aggregation (`GROUP BY`, `HAVING`)**: Explore how to summarize data using aggregate functions (`MAX`, `MIN`, `COUNT`, `AVG`) with `GROUP BY` and filter grouped results with `HAVING`.
* **Data Sorting (`ORDER BY`)**: Learn to sort your query results in ascending or descending order.
* **Limiting Results (`LIMIT`)**: Control the number of rows returned by your queries.
* **Aliasing**: Rename columns or tables for better readability.
* **Joins**: Connect data from multiple tables using `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, and `SELF JOIN`.
* **Unions**: Combine result sets from multiple `SELECT` statements.
* **String Functions**: Manipulate text data using functions like `TRIM`, `UPPER`, `LOWER`, `REPLACE`, `LENGTH`, `LEFT`, `RIGHT`, `SUBSTRING`, `LOCATE`, and `CONCAT`.
* **Case Statements**: Implement conditional logic within your queries.
* **Subqueries**: Utilize nested queries within `SELECT`, `WHERE`, and `FROM` clauses.
* **Window Functions**: Perform calculations across a set of table rows that are related to the current row, including `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`.
* **Common Table Expressions (CTEs)**: Organize complex queries into readable, manageable blocks.
* **Temporary Tables**: Create temporary storage for intermediate results within a session.
* **Stored Procedures**: Store and reuse SQL code blocks for repeatable tasks.
* **Triggers & Events**: Automate actions based on database events or scheduled times.
* **Table Renaming**: Learn how to rename tables.

---

## 🚀 Getting Started

To follow along with these queries, you'll need a MySQL environment.

### 1. Create the Database

The first step is to create the database named `tigif`:

```sql
CREATE DATABASE tigif;
USE tigif;
```

### 2. Create Tables and Insert Data

Run the following SQL to set up the `EmployeeDemographics` and `EmployeeSalary` tables and populate them with sample data:

#### **`EmployeeDemographics` Table**

```sql
Create Table EmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50)
);

Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male');
```

#### **`EmployeeSalary` Table**

```sql
Create Table EmployeeSalary
(EmployeeID int,
JobTitle varchar(50),
Salary int
);

Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000);
```

### 3. Execute Queries

Copy and paste the desired SQL queries from this repository into your MySQL client and execute them to see the results.

---

## 📖 Key Takeaways

* **Understanding `NULL` Values**: Pay attention to how `NULL` values behave in aggregations and comparisons.
* **Operator Precedence**: Remember the order of operations (like `PEMDAS` for arithmetic) applies in SQL queries.
* **Set-Based Operations**: SQL is highly optimized for set-based operations. While loops (via stored procedures, triggers, events) are available, often a single, well-crafted query can be more efficient.

---

Feel free to experiment with the data and modify the queries to deepen your understanding!

---
