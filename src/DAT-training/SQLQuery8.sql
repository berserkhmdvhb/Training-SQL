SELECT TOP 1 managers.email, employees.manager_id, employees.first_name, employees.last_name, jobs.job_title, ABS(employees.salary - jobs.max_salary) AS abs_diff FROM employees 
JOIN jobs ON employees.job_id = jobs.job_id
JOIN employees AS managers ON
employees.manager_id = managers.employee_id
WHERE YEAR(employees.hire_date) > 1995
ORDER BY abs_diff

