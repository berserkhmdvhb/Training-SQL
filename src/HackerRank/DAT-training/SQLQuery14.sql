SELECT employees.first_name,employees.last_name, countries.country_name,
CASE 
  WHEN countries.country_name IN ('United States of America', 'Canada')
	THEN 'New York City'
  WHEN countries.country_name = 'United Kingdom'
    THEN 'Paris'
	ELSE 'Not Invited'
END AS Destination
FROM employees 
JOIN departments ON departments.department_id = employees.department_id
JOIN locations ON locations.location_id = departments.location_id
JOIN countries
ON countries.country_id = locations.country_id
WHERE (first_name LIKE 'J%') OR (first_name LIKE 'H%')
