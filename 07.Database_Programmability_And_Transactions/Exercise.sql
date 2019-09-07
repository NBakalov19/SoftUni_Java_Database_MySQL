-- Part 1 SoftUni Database --
-- 1. Employees with Salary Above 35000 --
DELIMITER $
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT 
		first_name,
        last_name
	FROM employees
    WHERE salary > 35000
    ORDER BY
		first_name,
        last_name,
		employee_id ASC;
END $

-- 2. Employees with Salary Above Number --
CREATE PROCEDURE usp_get_employees_salary_above(salary_to_compare DECIMAL(18,4))
BEGIN 
		SELECT 
		first_name,
        last_name
	FROM employees
    WHERE salary >= salary_to_compare	
    ORDER BY
		first_name,
        last_name,
		employee_id ASC;
END $

-- 3. Town Names Starting With --
CREATE PROCEDURE usp_get_towns_starting_with(pattern VARCHAR(50))
BEGIN
	SELECT
		`name` AS `town_name`
	FROM towns
    WHERE `name` LIKE CONCAT(pattern,'%')
    ORDER BY town_name;
END $

-- 4.Employees from Town --
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(50))
BEGIN
	SELECT
		e.first_name,
        e.last_name
	FROM employees AS e
    JOIN addresses AS a ON e.address_id = a.address_id
    JOIN towns AS t ON a.town_id = t.town_id
    WHERE t.`name` = town_name
    ORDER BY 
		e.first_name,
        e.last_name,
        e.employee_id;
END $

-- 5. Salary Level Function --
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(19,4))
RETURNS VARCHAR(8)
BEGIN
	DECLARE result VARCHAR(8);
    
    IF salary < 30000 THEN SET result := 'Low';
    ELSEIF salary BETWEEN 30000 AND 50000 THEN SET result := 'Average';
    ELSEIF salary > 50000 THEN SET result := 'High';
    END IF;
    RETURN result;
END $

-- 6.Employees by Salary Level --
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(8))
BEGIN
	SELECT 
		first_name,
        last_name
	FROM employees
    WHERE salary_level = ufn_get_salary_level(salary)
    ORDER BY
		first_name DESC,
        last_name DESC;
END $

-- 7. Define Function --
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS INT
BEGIN
	DECLARE idx INT;
    DECLARE symbol VARCHAR(1);
    SET idx := 1;
    
    WHILE idx <= CHAR_LENGTH(word) DO
		SET symbol := SUBSTRING(word,idx,1);
        IF LOCATE(symbol,set_of_letters) = 0 THEN RETURN 0;
        END IF;
        SET idx := idx + 1;
	END WHILE;
    RETURN 1;
END $

-- Part 2 Bank Database --
-- 8. Find Full Name --
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN 
  SELECT 
	CONCAT(first_name, ' ', last_name) AS `full_name`
    FROM account_holders
    ORDER BY 
		full_name,
        id;
END $

-- 9. People with Balance Higher Than --
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(amount DECIMAL(19,4))
BEGIN
	SELECT 
		ah.first_name,
        ah.last_name
	FROM account_holders AS ah
    JOIN accounts AS a ON ah.id = a.account_holder_id
	GROUP BY 
		ah.first_name,
        ah.last_name
    HAVING SUM(a.balance) >= amount
    ORDER BY a.id;
END $

-- 10. Future value function --
CREATE FUNCTION ufn_calculate_future_value(init_sum DECIMAL(19,4), interest_rate DECIMAL(19,4), years INT(4))
RETURNS DECIMAL(19,4)
BEGIN
	DECLARE future_value DECIMAL(19,4);
    SET future_value := init_sum * POW(1 + interest_rate, years);
    RETURN future_value;
END; $

-- 11. Calculating interest -- 
CREATE PROCEDURE usp_calculate_future_value_for_account(acc_id INT, int_rate DECIMAL(10,4))
BEGIN
    SELECT 
		ac.id,
		ah.first_name,
        ah.last_name,
        ac.balance AS 'current_balance',
		ufn_calculate_future_value(ac.balance, int_rate, 5) AS 'balance_in_5_years'
    FROM account_holders AS ah
    JOIN accounts AS ac
    ON ac.account_holder_id = ah.id
    WHERE ac.id = acc_id;
END; $

-- 12. Deposit money --
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN 
	START TRANSACTION;
	UPDATE accounts
	SET balance = balance + ROUND(money_amount,4)
	WHERE id = account_id;
	COMMIT;

END; $ -- 60/100 --

-- 13. Withdraw money -- 
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19.4))
BEGIN
	START TRANSACTION;
    IF money_amount <= 0 THEN ROLLBACK;
    ELSEIF money_amount > (
		SELECT balance 
		FROM accounts
		WHERE id = account_id
		) THEN ROLLBACK;
	ELSE
		UPDATE accounts
		SET balance = balance - money_amount
		WHERE id = account_id;
        COMMIT;
    END IF;
END; $

-- 14. Money Transfer --
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DOUBLE)
BEGIN
    START TRANSACTION;
        UPDATE accounts
        SET balance = balance - amount
        WHERE id = from_account_id;
        UPDATE accounts
        SET balance = balance + amount
        WHERE id = to_account_id;
    IF amount < 0
        THEN ROLLBACK;
    END IF;
    IF (SELECT count(*) FROM accounts WHERE id IN (from_account_id, to_account_id)) <> 2
        THEN ROLLBACK;
    END IF;
    IF (SELECT balance FROM accounts WHERE id = from_account_id) < 0
        THEN ROLLBACK;
    END IF;
END $

-- 15 --
CREATE TABLE `logs`(
log_id INT PRIMARY KEY AUTO_INCREMENT,
account_id INT,
old_sum DECIMAL(14, 4),
new_sum DECIMAL(14, 4)
); $
 
CREATE TRIGGER tr_change_balance
AFTER UPDATE
ON accounts
FOR EACH ROW
BEGIN
    INSERT INTO `logs`
    (account_id, old_sum, new_sum)
    VALUES
    (OLD.id, OLD.balance, NEW.balance);
END; $

-- 16. -- 
CREATE TABLE notification_emails(
id INT PRIMARY KEY AUTO_INCREMENT,
recipient INT,
`subject` VARCHAR(40),
body VARCHAR(255)
); $
 
CREATE TRIGGER tr_notification_email
AFTER INSERT
ON `logs`
FOR EACH ROW
BEGIN
    INSERT INTO notification_emails
    (recipient, `subject`, body)
    VALUES
    (NEW.account_id, concat('Balance change for account: ', NEW.account_id),
    concat('On ', NOW(), ' your balance was changed from ', NEW.old_sum, ' to ', NEW.new_sum, '.'));
END $