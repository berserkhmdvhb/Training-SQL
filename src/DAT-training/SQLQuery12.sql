SELECT COALESCE(departments.department_name, 'All') AS departmentName, COALESCE(jobs.job_title, 'All') AS jobTitle, COUNT(employees.employee_id) AS employee_count		
FROM employees
JOIN departments
ON employees.department_id = departments.department_id
JOIN jobs
ON jobs.job_id = employees.job_id
GROUP BY
  GROUPING SETS
  (
   (departments.department_name, jobs.job_title),
   departments.department_name,
   jobs.job_title
  )
  ORDER BY departments.department_name, jobs.job_title
  