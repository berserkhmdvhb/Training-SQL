SELECT job_title, (min_salary + max_salary) / 2 AS avg_salary FROM dbo.jobs ORDER BY avg_salary DESC, job_title DESC

