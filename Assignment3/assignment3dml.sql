--Angel Baez Assignment 3

-- 1.  We want to spend some advertising money - where should we spend it?
--     I.e., What is the best referral source of our buyers?
\echo 'Most frequently occurring referrals, or best referral source'
SELECT 
	referrer, 
	COUNT(referrer) AS num_buyers_used
FROM
	buyer
GROUP BY
	referrer 
ORDER BY
	COUNT(referrer) DESC;
	
--2.  Which of our customers has not bought a boat yet?
\echo 'Customer who have yet to buy a boat'
SELECT 
	buyer.fname, buyer.lname, buyer.cust_id
FROM
	buyer
LEFT OUTER JOIN
	"transaction" 
ON	
	buyer.cust_id = "transaction".cust_id
WHERE 
	"transaction".trans_id IS NULL;
	
--3.  Which boats do we have in inventory - i.e., have not sold?
\echo 'Boats that have not sold'
SELECT
	a.brand, a.category, a.prod_id,
	a.price
FROM
	boat a
LEFT OUTER JOIN
	"transaction" b 
ON
	a.prod_id = b.prod_id
WHERE 
	b.trans_id IS NULL;

--4.  What boat did Alan Weston buy?
\echo 'Boat that Alan Weston purchased'
SELECT
	a.brand, a.category, a.prod_id,
	a.price
FROM
	boat a
INNER JOIN
	"transaction" b
ON 
	a.prod_id = b.prod_id
INNER JOIN
	buyer c
ON
	b.cust_id = c.cust_id
WHERE
	c.lname = 'Weston' AND c.fname = 'Alan';
	
--5. Who are our VIP customers?
--   I.e., Has anyone bought more than one boat?
\echo 'VIP customers'
WITH cust_bought AS (
	SELECT 
		a.cust_id, a.fname, a.lname
	FROM
		buyer a
	INNER JOIN 
		transaction b
	ON
		a.cust_id = b.cust_id
	)
SELECT
	c.fname, c.lname, c.cust_id,
	COUNT(c.cust_id) AS boats_purchased
FROM
	cust_bought c
GROUP BY 
	c.cust_id, c.fname, c.lname
HAVING 
	COUNT(c.cust_id) > 1;

	