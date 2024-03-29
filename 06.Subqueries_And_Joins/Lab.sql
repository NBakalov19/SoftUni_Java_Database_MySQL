-- 1 Managers -- 
SELECT 
	`e`.`employee_id`,
    CONCAT(`e`.`first_name`, ' ' ,`e`.`last_name`) AS `full_name`,
    `d`.`department_id`,
    `d`.`name` AS `department_name`
FROM `employees` AS `e`
JOIN `departments` AS `d`
ON `d`.`manager_id` = `e`.`employee_id`
ORDER BY `e`.`employee_id` LIMIT 5;

-- 2 Town and addresses -- 
SELECT 
	`t`.`town_id`,
    `t`.`name`,
    `a`.`address_text`
FROM 
	`towns` AS `t`
JOIN `addresses` AS `a` ON `t`.`town_id` = `a`.`town_id`
WHERE `t`.`name` IN ('San Francisco', 'Sofia','Carnation')
ORDER BY `t`.`town_id`, `a`.`address_id`;

-- 3 Employees without managers --
SELECT 
	employee_id,
    first_name,
    last_name,
    department_id,
    salary
FROM 
	employees
WHERE manager_id IS NULL;

-- 4 High salary --
SELECT COUNT(employee_id) FROM employees
WHERE salary > 
(
SELECT AVG(salary) FROM employees
);