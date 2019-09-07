-- 1. Employees address -- 
SELECT 
	e.employee_id,
    e.job_title,
    a.address_id,
    a.address_text
FROM employees AS `e`
JOIN addresses AS `a`
ON e.address_id = a.address_id
ORDER BY address_id ASC LIMIT 5;

-- 2. Addresses with towns --
SELECT 
	e.first_name,
    e.last_name,
    t.name,
    a.address_text
FROM employees AS `e`
JOIN addresses AS `a` ON e.address_id = a.address_id
JOIN towns AS `t` ON a.town_id = t.town_id
ORDER BY e.first_name, e.last_name LIMIT 5;

-- 3. Sales employee --
SELECT 
	e.employee_id,
    e.first_name,
    e.last_name,
    d.name AS `department_name`
FROM 
	employees AS `e`
JOIN departments AS `d` ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;

-- 4. Employee Departments --
SELECT
	e.employee_id,
    e.first_name,
    e.salary,
	d.name AS `department_name`
FROM 
	employees AS `e`
JOIN departments AS `d` ON d.department_id = e.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC LIMIT 5;

-- 5. Employees Without Project --
SELECT DISTINCT
	e.employee_id,
    e.first_name
FROM employees AS `e`
RIGHT JOIN employees_projects AS `ep` ON e.employee_id NOT IN
(
SELECT DISTINCT employee_id FROM employees_projects 
)
ORDER BY e.employee_id DESC LIMIT 3;

-- 6. Employees hired after -- 
SELECT 
	e.first_name,
    e.last_name,
    e.hire_date,
    d.name AS `dept_name`
FROM employees AS `e`
JOIN departments AS `d` ON d.department_id = e.department_id AND DATE (e.hire_date) > '1999/1/1' AND d.name IN ('Sales', 'Finance')
ORDER BY e.hire_date ASC;

-- 7. Employees with Project --
SELECT 
	e.employee_id,
    e.first_name,
    p.name AS `project_name`
FROM employees AS e
JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
JOIN projects AS p ON ep.project_id = p.project_id 
WHERE DATE (p.start_date) > '2002/08/13' AND p.end_date IS NULL
ORDER BY e.first_name, p.name LIMIT 5;

-- 8. Employee 24 --
SELECT 
	e.employee_id,
    e.first_name,
	CASE
		WHEN DATE (p.start_date) >= '2005/01/01' THEN NULL
        ELSE p.name
        END AS `project_name`
FROM employees AS e
JOIN employees_projects AS ep ON ep.employee_id = e.employee_id AND ep.employee_id = 24
JOIN projects AS p ON p.project_id = ep.project_id
ORDER BY project_name;

-- 9. Employee manager --
SELECT
	e.employee_id,
    e.first_name,
    e.manager_id,
    m.first_name AS `manager_name`
FROM employees AS e
JOIN employees AS m ON e.manager_id = m.employee_id AND e.manager_id IN (3,7)
ORDER BY e.first_name;

-- 10. Employee Summary --
SELECT
	e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS `employee_name`,
    CONCAT(m.first_name, ' ', m.last_name) AS `manager_name`,
    d.name AS `department_name`
FROM employees AS e
JOIN employees AS m ON e.manager_id = m.employee_id
JOIN departments AS d ON e.department_id = d.department_id
ORDER BY e.employee_id LIMIT 5;

-- 11. Min average salary --
SELECT MIN(average_salary_by_department) AS `min_average_salary`
FROM 
	(
	SELECT AVG(salary) AS `average_salary_by_department`
	FROM employees
	GROUP BY department_id 
	) AS `average_salary`;

-- 12. Highest peeks in Bulgaria -- 
-- Geography database --
SELECT 
	c.country_code,
    m.mountain_range,
    p.peak_name,
    p.elevation
FROM countries AS c
JOIN mountains_countries AS mc ON c.country_code = mc.country_code AND c.country_code = 'BG'
JOIN mountains AS m ON mc.mountain_id = m.id 
JOIN peaks AS p ON m.id = p.mountain_id AND p.elevation > 2835
ORDER BY p.elevation DESC;

-- 13. Count mountain ranges --
SELECT 
	c.country_code,
    COUNT(mc.mountain_id) AS `mountain_range`
FROM countries AS c
JOIN mountains_countries AS mc ON c.country_code = mc.country_code AND c.country_code IN('BG','RU','US')
GROUP BY c.country_code
ORDER BY mountain_range DESC; 

-- 14. Countries with rivers --
SELECT 
	c.country_name,
    r.river_name
FROM rivers AS r
JOIN countries_rivers AS cr ON r.id = cr.river_id
RIGHT OUTER JOIN countries AS c ON c.country_code = cr.country_code
WHERE c.continent_code = 'AF'
ORDER BY c.country_name LIMIT 5;

-- 15. Continents and Currencies* --
SELECT
    allc.continent_code,
    allc.currency_code,
    allc.currency_usage
FROM
    (SELECT
        continent_code,
        currency_code,
        max(currency_usage) AS currency_usage
    FROM
        (SELECT
            continent_code,
            currency_code,
            count(currency_code) AS currency_usage
        FROM countries
        GROUP BY continent_code, currency_code
        ) AS group_currency
    GROUP BY continent_code) AS maxims,
    (SELECT
        continent_code,
        currency_code,
        count(currency_code) AS currency_usage
    FROM countries
    GROUP BY continent_code, currency_code
    HAVING currency_usage > 1
    ) AS allc
WHERE allc.continent_code = maxims.continent_code AND allc.currency_usage = maxims.currency_usage
ORDER BY
    continent_code,
    currency_code;

-- 16. Countries without any mountains --
CREATE VIEW `view_all_countries` AS 
SELECT COUNT(country_code) AS `all_countries`
FROM countries;
CREATE VIEW `view_countries_with_mountains` AS 
SELECT COUNT(DISTINCT country_code) AS `countries_with_mountains` 
FROM mountains_countries;
SELECT a.all_countries - b.countries_with_mountains AS `country_count`
FROM view_all_countries AS a
JOIN view_countries_with_mountains AS b ON a.all_countries IS NOT NULL;

-- 17. Highest peak and longest river by country --
SELECT 
	c.country_name,
    MAX(p.elevation) AS 'highest_peak_elevation',
    MAX(r.length) AS 'longest_river_length'
FROM countries AS c
LEFT JOIN mountains_countries AS mc ON mc.country_code = c.country_code
LEFT JOIN peaks AS p ON mc.mountain_id = p.mountain_id
LEFT JOIN countries_rivers AS cr ON cr.country_code = c.country_code
LEFT JOIN rivers as r ON cr.river_id = r.id
GROUP BY c.country_name
ORDER BY 
	highest_peak_elevation DESC, 
    longest_river_length DESC,
    c.country_name 
	LIMIT 5;
