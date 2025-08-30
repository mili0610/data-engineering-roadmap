CREATE DATABASE PracticeDB;
USE PracticeDB;

-- Employees table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary INT
);

INSERT INTO Employees VALUES
(1, 'Alice', 10, 50000),
(2, 'Bob', 20, 60000),
(3, 'Charlie', 10, 55000),
(4, 'David', 30, 45000),
(5, 'Eva', NULL, 70000);

-- Departments table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO Departments VALUES
(10, 'IT'),
(20, 'HR'),
(30, 'Finance'),
(40, 'Marketing');

-- Employee_Manager table
CREATE TABLE Employee_Manager (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    manager_id INT
);

INSERT INTO Employee_Manager VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Charlie', 1),
(4, 'David', 2),
(5, 'Eva', 2);


-- Q1. List all employees along with their department names (only those who belong to a department).
SELECT E.emp_name, D.dept_name FROM Employees E With (nolock)
INNER JOIN Departments D WITH (NOLOCK) ON E.dept_id = D.dept_id

-- Q2. List all employees and their department names. Show NULL if they don’t belong to any department.
SELECT E.emp_name, D.dept_name FROM Employees E With (nolock)
left JOIN Departments D WITH (NOLOCK) ON E.dept_id = D.dept_id

-- Q3. Find employees who don’t belong to any department.
SELECT E.emp_name, D.dept_name FROM Employees E With (nolock)
left JOIN Departments D WITH (NOLOCK) ON E.dept_id = D.dept_id
where D.dept_name is null

-- Q4. Get the employee(s) with the second highest salary.
SELECT * FROM Employees WITH (NOLOCK)
WHERE salary = (SELECT MAX(SALARY) FROM Employees WITH (NOLOCK) WHERE salary < (SELECT MAX(SALARY) FROM Employees))

SELECT emp_name, salary
FROM Employees
ORDER BY salary DESC
OFFSET 1 ROWS
FETCH NEXT 1 ROWS ONLY

-- Q5. Find the top 2 highest-paid employees within each department.
SELECT emp_name, dept_id,salary FROM 
(SELECT E.emp_name, E.dept_id, E.salary, RANK() OVER (PARTITION BY E.dept_id ORDER BY E.salary DESC) AS rnk
from Employees E
LEFT JOIN Departments D ON E.dept_id = D.dept_id
) ranked
where rnk <=2

-- Q6. List all employees with their manager names. Show NULL if no manager exists.
SELECT E.emp_name, D.emp_name as 'Manager_Name' FROM Employee_Manager E With (nolock)
left JOIN Employee_Manager D WITH (NOLOCK) ON E.emp_id = D.manager_id


-- Q7. Find the average salary per department.
SELECT D.dept_name, AVG(salary) FROM Employees E With (nolock)
 JOIN Departments D WITH (NOLOCK) ON E.dept_id = D.dept_id 
 GROUP BY D.dept_name



-- Q8. Find employees who earn more than the average salary of their department.
SELECT E.emp_name, D.dept_name, E.salary FROM Employees E With (nolock)
left JOIN Departments D WITH (NOLOCK) ON E.dept_id = D.dept_id
where e.salary > (select avg(salary) from Employees where dept_id = e.dept_id)
