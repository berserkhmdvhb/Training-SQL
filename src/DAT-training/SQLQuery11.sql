SELECT employees.first_name, employees.last_name
FROM employees
UNION
SELECT customers.firstname, customers.lastname FROM customers
ORDER BY last_name