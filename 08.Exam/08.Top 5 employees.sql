SELECT
	CONCAT(e.first_name, ' ',last_name) AS `name`,
    e.started_on,
    (COUNT(ec.employee_id)) AS count_of_clients
FROM employees AS e
JOIN employees_clients as ec ON e.id = ec.employee_id
GROUP BY ec.employee_id
ORDER BY 
	count_of_clients DESC,
    e.id
    LIMIT 5;