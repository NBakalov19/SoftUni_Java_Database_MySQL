DELIMITER $

CREATE FUNCTION udf_client_cards_count(check_name VARCHAR(30))
RETURNS INT
BEGIN
	DECLARE card_count INT;
		SET card_count := (
			SELECT COUNT(c.id)
            FROM cards AS c
            JOIN bank_accounts AS ba ON c.bank_account_id = ba.id
            JOIN clients AS cl On ba.client_id = cl.id
            WHERE cl.full_name = check_name
        );
        
	RETURN card_count;
END;$

SELECT
	c.full_name, 
	udf_client_cards_count('Baxy David') as `cards` 
    FROM clients c
WHERE c.full_name = 'Baxy David';
