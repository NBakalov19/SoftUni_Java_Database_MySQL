UPDATE employees_clients
SET employee_id = (
	SELECT 
		e.id
	FROM employees AS e
	JOIN (
		SELECT
			employee_id,
			COUNT(employee_id) AS my_count
		FROM employees_clients
		GROUP BY employee_id
		ORDER BY 
			my_count ASC,
			employee_id ASC LIMIT 1) AS j 
	ON j.employee_id = e.id
)
WHERE client_id = employee_id;