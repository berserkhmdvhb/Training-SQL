SELECT MAX(Salary) 
FROM employee
WHERE Salary <
(SELECT Max(Salary) FROM employee)

SELECT salary
FROM employee
ORDER BY salary DESC
LIMIT 1
OFFSET 1
