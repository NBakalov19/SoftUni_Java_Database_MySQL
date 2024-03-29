/*Task 1
SOFT_UNI DATABASE*/
SELECT `first_name`, `last_name` FROM `employees`
WHERE SUBSTRING(`first_name`,1,2) = 'Sa' ORDER BY `employee_id`;

/*Task 2*/
SELECT `first_name`, `last_name` FROM `employees`
WHERE `last_name` LIKE '%ei%' ORDER BY `employee_id`;

/*Task 3*/
SELECT `first_name` FROM `employees`
WHERE `department_id` IN (3,10)
AND YEAR(`hire_date`) >= 1995 AND YEAR(`hire_date`) <= 2005
ORDER BY `employee_id`;

/*Task 4*/
SELECT `first_name`, `last_name`
FROM `employees`
WHERE `job_title` NOT LIKE '%engineer%';

/*Task 5*/
SELECT `name` FROM `towns`
WHERE LENGTH(`name`) IN (5,6)
ORDER BY `name` ASC;

/*Task 6*/
SELECT `town_id`, `name` FROM `towns`
WHERE LEFT(`name`,1) IN ('M', 'K', 'B', 'E')
ORDER BY `name` ASC;

/*Task 7*/
SELECT `town_id`, `name` FROM `towns`
WHERE LEFT(`name`,1) NOT IN ('R', 'B', 'D')
ORDER BY `name` ASC;

/*Task 8*/
CREATE VIEW `v_employees_hired_after_2000` AS
SELECT `first_name`, `last_name` FROM `employees`
WHERE YEAR(`hire_date`) > 2000;
SELECT * FROM `v_employees_hired_after_2000`;

/*Task 9*/
SELECT `first_name`, `last_name` FROM `employees`
WHERE LENGTH(`last_name`) = 5;

/*Task 10*/
/*GEOGRAPHY DATABASE*/
SELECT `country_name`, `iso_code` FROM `countries`
WHERE `country_name` LIKE '%a%a%a%' 
ORDER BY `iso_code`;

/*Task 11*/
SELECT p.`peak_name`,
r.`river_name`, 
LOWER(CONCAT(p.`peak_name`,SUBSTRING(r.`river_name`,2))) AS `mix`
FROM `peaks` as p, `rivers` as r
WHERE RIGHT(p.`peak_name`,1 ) = LEFT(r.`river_name`,1)
ORDER BY `mix`;

/*Task 12*
DIABLO DATABASE*/
SELECT `name`,
DATE_FORMAT (`start`, '%Y-%m-%d') as `start`
FROM `games`
WHERE YEAR(`start`) IN (2011,2012)
ORDER BY `start` , `name` DESC LIMIT 50;
 
/*Task 13*/
SELECT `user_name`,
SUBSTRING_INDEX(`email`,'@', -1) AS 'Email Provider'
FROM `users`
ORDER BY `Email Provider` ASC,
`user_name`;

/*Task 14*/
SELECT `user_name`,`ip_address`
FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`; 

/*Task 15*/
SELECT `name` as 'game',
CASE
WHEN HOUR(`start`) >= 0 AND HOUR(`start`) < 12 THEN 'Morning'
WHEN HOUR(`start`) >= 12 AND HOUR(`start`) < 18 THEN 'Afternoon'
WHEN HOUR(`start`) >= 18 AND HOUR(`start`) < 24 THEN 'Evening'
END AS `Part of the day`,
CASE 
WHEN `duration` BETWEEN 0 AND 3 THEN 'Extra Short'
WHEN `duration` BETWEEN 3 AND 6 THEN 'Short'
WHEN `duration` BETWEEN 6 AND 10 THEN 'Long'
ELSE 'Extra Long'
END AS `Duration`
FROM `games`;

/*Task 16
ORDERS DATABASE*/
SElECT `product_name`, `order_date`,
DATE_ADD(`order_date`, INTERVAL 3 DAY) AS `pay_due`,
DATE_ADD(`order_date`, INTERVAL 1 MONTH) AS `deliver_due`
FROM `orders`;