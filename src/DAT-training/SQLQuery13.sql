SELECT employees.first_name, employees.last_name, jobs.job_title
		FROM employees 
		INNER JOIN jobs ON jobs.job_id = employees.job_id 
		WHERE manager_id IN 
			(
				SELECT employee_id FROM employees WHERE first_name = 'Neena'
			)