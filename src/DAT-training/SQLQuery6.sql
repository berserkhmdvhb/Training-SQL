SELECT  departments.department_name, COUNT(employees.employee_id) AS employ_count FROM employees 
INNER JOIN departments ON employees.department_id = departments.department_id 
WHERE departments.department_name LIKE 'I%'
GROUP BY departments.department_name 
HAVING COUNT(employees.employee_id) > 1