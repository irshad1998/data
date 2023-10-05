## <u>Project Folder Structure</u>
- **project-root/**
    - **.git/**
    - **.github/**
        - **workflows/**
            - `workflow.yaml`
    - **node_modules/** - `node package files`
    - **src/**
        - **api/**
            - **v1**
                - **routes/**
                - **middlewares/**
                    - `validate.ts`
                - **swagger/**
                    - `components.json`
                    - `openapi.json`
                    - `swagger.ts`
            - **v2**
                - **routes/**
                - **middlewares/**
                    - `validate.ts`
                - **swagger/**
                    - `components.json`
                    - `openapi.json`
                    - `swagger.ts`
        - **app/**
            - **v1** `- App logics here by version 1`
                - **validators/**
            - **v2** `- App logics here by version 2`
                - **validators/**
        - **services/**
            - **dbengine/**
                - `index.ts`
                - `helper.ts`
                - `worker.ts`
        - **utils/**
            - `aenv.ts`
            - `standards.ts`
        - **environments/**
            - `.env`
        - **interfaces/**
        - **migrations/**
        - `index.ts`
    - `.gitignore`
    - `pakage.json`
    - `pakage.json`
    - `pakage-lock.json`
    - `README.MD`
    - `tsconfig.json`

###<u> Postgresql Imp. Commands</u>
- **<u>CREATE ROLE</u>**
```sql
CREATE USER myuser WITH PASSWORD 'strongpassword';
```
- **<u>CREATE DATABASE</u>**
```sql
CREATE DATABASE mydatabase;
```
- **<u>GRANT ALL PRIVILEGES</u>**
```sql
-- Grant SUPERUSER privileges to myuser
ALTER USER myuser WITH SUPERUSER;
-- or
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO main;
ALTER USER main CREATEDB;
```

- **<u>TABLE QUERIES</u>**

```sql
-- Create table
CREATE TABLE users (
    id integer serial,
    user_id uuid UNIQUE NOT NULL PRIMARY KEY,
    name VARCHAR(64),
    mobile VARCHAR(10),
    dob timestamp
    cart_id uuid REFERENCES cart(cart_id),
);

-- Insert into table
INSERT INTO users (
    user_id,
    name, 
    mobile, 
    dob, 
    cart_id
) VALUES (
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx',
    'Irshad',
    '9744477794',
    '0000-00-00 00:00:00',
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
);

-- Select from
SELECT * FROM users;
SELECT name, mobile FROM users WHERE user_id = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx';
SELECT count(users_id) FROM users WHERE user_id = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
SELECT name AS users, mobile AS mobile FROM users;
-- Retrieve distinct (unique) values from a column.
SELECT DISTINCT dob FROM users;
SELECT * FROM users ORDER BY column_name ASC/DESC;
SELECT * FROM users LIMIT 10;
SELECT AVG(credits) FROM users;
-- Joins
SELECT * FROM users INNER JOIN cart ON users.user_id = cart.user_id;
SELECT column1 FROM table_name WHERE column2 IN (SELECT column2 FROM another_table);
SELECT username
-- Union select (Set) with sub query
FROM (
    SELECT username FROM users1
    UNION
    SELECT username FROM users2
) AS set_of_users;

-- INNER JOIN
-- Returns only the rows that have matching values in both tables.
SELECT *
FROM table1
INNER JOIN table2 ON table1.column_name = table2.column_name;

-- LEFT JOIN (or LEFT OUTER JOIN)
-- Returns all rows from the left table and the matched rows from the right table.
-- If there is no match, NULL values are returned from the right table. 
SELECT *
FROM table1
LEFT JOIN table2 ON table1.column_name = table2.column_name;

-- RIGHT JOIN (or RIGHT OUTER JOIN)
-- Returns all rows from the right table and the matched rows from the left table. If there is no -- match, NULL values are returned from the left table.
SELECT *
FROM table1
RIGHT JOIN table2 ON table1.column_name = table2.column_name;

-- FULL JOIN (or FULL OUTER JOIN)
-- Returns all rows when there is a match in either the left or the right table. If there is no
-- match, NULL values are returned for missing values.
SELECT *
FROM table1
FULL JOIN table2 ON table1.column_name = table2.column_name;

-- CROSS JOIN
-- Returns the Cartesian product of both tables, combining each row from the first table with 
-- every row from the second table.
SELECT *
FROM table1
CROSS JOIN table2;

-- SELF JOIN
-- Joins a table to itself, typically when you want to compare or relate rows within the same
-- table.
SELECT employee1.name, employee2.name
FROM employees AS employee1
INNER JOIN employees AS employee2 ON employee1.manager_id = employee2.employee_id;

-- NON-EQUI JOIN
-- Performs a join using a condition other than equality (e.g., greater than, less than) to match -- rows from the tables.
SELECT *
FROM orders
INNER JOIN customers ON orders.customer_id > customers.customer_id;

-- Update table
UPDATE users SET mobile = '9744477794', name = 'Irshad' WHERE id = 0;

-- DELETE All Rows from a Table
DELETE FROM table_name;

-- DELETE with a WHERE Clause (Delete specific rows)
DELETE FROM table_name WHERE condition;

-- DELETE with a JOIN (Delete rows based on a JOIN condition)
DELETE FROM table1
WHERE table1.column_name = table2.column_name;

-- DELETE with a Subquery (Delete rows based on a subquery)
DELETE FROM table_name WHERE column_name IN (SELECT column_name FROM another_table);

-- DELETE with a LIMIT (Delete the top N rows)
DELETE FROM table_name LIMIT n;

-- DELETE with a RETURNING Clause (Delete and return deleted data)
DELETE FROM table_name RETURNING column_name;

-- TRUNCATE TABLE (Remove all rows from a table, faster than DELETE)
TRUNCATE TABLE table_name;

-- DELETE Cascade (Delete with cascading foreign key constraints)
DELETE FROM table_name WHERE condition CASCADE;

-- DELETE using Common Table Expression (CTE)
WITH cte AS (
   SELECT column_name FROM table_name WHERE condition
)
DELETE FROM table_name WHERE column_name IN (SELECT column_name FROM cte);

-- DROP TABLE: Deletes a table and all its data
DROP TABLE table_name;

-- DROP INDEX: Removes an index from a table
DROP INDEX index_name;

-- DROP VIEW: Deletes a view
DROP VIEW view_name;

-- DROP DATABASE: Removes an entire database and all its objects
DROP DATABASE database_name;

-- DROP SCHEMA: Deletes a schema and all objects within it
DROP SCHEMA schema_name;

-- DROP FUNCTION: Removes a user-defined function
DROP FUNCTION function_name;

-- DROP PROCEDURE: Deletes a stored procedure
DROP PROCEDURE procedure_name;

-- DROP TRIGGER: Removes a trigger from a table
DROP TRIGGER trigger_name ON table_name;

-- DROP ROLE: Deletes a database role or user
DROP ROLE role_name;

-- DROP DOMAIN: Removes a user-defined domain
DROP DOMAIN domain_name;

--------
-- Other 
--------
-- INSERT INTO: Adds new rows of data into a table
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);

-- UPDATE: Modifies existing data in a table
UPDATE table_name
SET column1 = value1, column2 = value2
WHERE condition;

-- CREATE TABLE: Creates a new table with specified columns and data types
CREATE TABLE table_name (
   column1 datatype1,
   column2 datatype2,
   ...
);

-- ALTER TABLE: Modifies an existing table, such as adding, modifying, or dropping columns
ALTER TABLE table_name
ADD column_name datatype;

-- DESC or SHOW COLUMNS: Retrieves information about the columns in a table
DESC table_name;
-- or
SHOW COLUMNS FROM table_name;

-- SELECT INTO: Creates a new table based on the results of a SELECT query
SELECT column1, column2, ...
INTO new_table
FROM source_table
WHERE condition;

-- TRUNCATE TABLE: Removes all rows from a table but retains the table structure
TRUNCATE TABLE table_name;

-- RENAME TABLE: Changes the name of an existing table
RENAME TABLE old_table_name TO new_table_name;

-- COPY: Imports data into a table from an external file (common in PostgreSQL)
COPY table_name FROM 'file_path' DELIMITER ',' CSV;

-- GRANT and REVOKE: Assigns or revokes privileges and permissions on a table to users or roles
GRANT SELECT, INSERT, UPDATE ON table_name TO user_or_role;
-- or
REVOKE SELECT, INSERT, UPDATE ON table_name FROM user_or_role;


```

    
