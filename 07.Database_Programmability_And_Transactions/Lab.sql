DELIMITER $$ 
-- 1. Count Employees by Town --

CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(20))
RETURNS INT
BEGIN 
	DECLARE employees_count INT;
    SET employees_count := ( 
		SELECT COUNT(employee_id) FROM employees AS e
        JOIN addresses AS a ON a.address_id = e.address_id
        JOIN towns AS t ON t.town_id = a.town_id
        WHERE t.name = town_name
	);
	RETURN employees_count;
END $$
     
-- 2. Employees Promotion --
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(20))
BEGIN
	UPDATE employees AS e
    JOIN departments as d ON d.department_id = e.department_id
    SET e.salary = e.salary * 1.05
    WHERE d.name = department_name;
END $$

-- 3. Employees Promotion By ID --
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
	UPDATE employees 
    SET salary = salary * 1.05
    WHERE employee_id = id;
END $$
