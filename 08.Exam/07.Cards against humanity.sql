SELECT 
	cd.id,
    CONCAT(cd.card_number,' : ', c.full_name) AS card_token
FROM cards AS cd
JOIN bank_accounts AS ba ON cd.bank_account_id = ba.id
JOIN clients AS c ON ba.client_id = c.id
ORDER BY cd.id DESC;