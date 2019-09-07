/*Task 1
GRINGOTTS DATABASE*/
SELECT COUNT(*) FROM `wizzard_deposits`;

/*Task 2*/
SELECT MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM `wizzard_deposits`;

/*Task 3*/
SELECT `deposit_group`,
MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `longest_magic_wand`, `deposit_group`;

/*Task 4*/
SELECT MIN(`deposit_group`)
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY AVG(`magic_wand_size`) LIMIT 1;

/*Task 5*/
SELECT `deposit_group`,
SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `total_sum`;

/*Task 6*/
SELECT `deposit_group`,
SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
ORDER BY `deposit_group`;

/*Task 7*/
SELECT `deposit_group`,
SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;

/*Task 8*/
SELECT 
	`deposit_group`,
	`magic_wand_creator`,
	MIN(`deposit_charge`) AS 'min_deposit_charge'
FROM 
	`wizzard_deposits`
GROUP BY 
	`deposit_group`,
    `magic_wand_creator`
ORDER BY 
	`magic_wand_creator`,
    `deposit_group`;

/*Task 9*/
SELECT 
CASE 
	WHEN `age` <= 10 THEN '[0-10]'
	WHEN `age` > 10 AND `age` <= 20 THEN '[11-20]'
	WHEN `age` > 20 AND `age` <= 30 THEN '[21-30]'
	WHEN `age` > 30 AND `age` <= 40 THEN '[31-40]'
	WHEN `age` > 40 AND `age` <= 50 THEN '[41-50]'
	WHEN `age` > 50 AND `age` <= 60 THEN '[51-60]'
	ELSE '[61+]'
END AS `age_group`,
COUNT(*) AS 'wizard_count'
FROM `wizzard_deposits`
GROUP BY `age_group`
ORDER BY `age_group`;

/*Task 10*/
SELECT SUBSTRING(`first_name`,1,1) AS 'first_letter'
FROM `wizzard_deposits`
WHERE `deposit_group` = 'Troll Chest'
GROUP BY `first_letter`
ORDER BY `first_letter`;

/*Task 11*/
SELECT 
	`deposit_group`,
    `is_deposit_expired`,
    AVG(`deposit_interest`) AS 'average_interest'
FROM 
	`wizzard_deposits`
WHERE 
	`deposit_start_date` > '1985/01/01'
GROUP BY 
    `is_deposit_expired`,
    `deposit_group`
ORDER BY
	`deposit_group` DESC,
    `is_deposit_expired`;

/*Task 12*/
SELECT SUM(diff.next) AS 'sum_difference'
FROM  (
	SELECT `deposit_amount` - 
		(SELECT `deposit_amount` 
        FROM `wizzard_deposits`
        WHERE `id` = curr.id + 1) AS 'next'
	FROM `wizzard_deposits` AS curr) AS diff;
    
/*Task 13
SOFTUNI DATABASE*/
SELECT 
	`department_id`,
    MIN(`salary`) AS 'minimum_salary'
FROM `employees`
WHERE `department_id` IN (2,5,7) AND `hire_date` > '2000/01/01'
GROUP BY `department_id`
ORDER BY `department_id`;

/*Task 14*/
CREATE TABLE EmployeesWithHighSalary
SELECT * FROM `employees`
WHERE `salary` > 30000;

DELETE FROM `employeeswithhighsalary`
WHERE `manager_id` = 42;

UPDATE `employeeswithhighsalary`  
SET `salary` = `salary` + 5000
WHERE `department_id` = 1;

SELECT 
	`department_id`,
    AVG(`salary`) AS 'avg_salary'
FROM `employeeswithhighsalary`
GROUP BY `department_id`
ORDER BY `department_id`;

/*Task 15*/
SELECT 
	`department_id`,
    MAX(`salary`) AS 'max_salary'
FROM `employees`
GROUP BY `department_id`
HAVING `max_salary` NOT BETWEEN 30000 AND 70000
ORDER BY `department_id`;

/*Task 16*/
SELECT COUNT(*)
FROM `employees`
WHERE `manager_id` IS NULL;

/*Task 17*/
SELECT
    `department_id`,
    (SELECT DISTINCT
            `e2`.`salary`
        FROM
            `employees` AS `e2`
        WHERE
            `e2`.`department_id` = `e1`.`department_id`
        ORDER BY `e2`.`salary` DESC
        LIMIT 2 , 1) AS `third_highest_salary`
FROM
    `employees` AS `e1`
GROUP BY `department_id`
HAVING `third_highest_salary` IS NOT NULL;
/*Task 18*/
SELECT 
	`first_name`,
    `last_name`,
    `department_id`
FROM `employees` AS e1
WHERE e1.salary > (
	SELECT AVG(`salary`) FROM `employees` AS e2
    WHERE e1.department_id = e2.department_id
)
ORDER BY e1.department_id ASC LIMIT 10;

/*Task 19*/
SELECT 
	`department_id`,
    SUM(`salary`) AS 'total_salary'
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;