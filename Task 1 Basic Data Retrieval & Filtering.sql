SELECT -- option 1
	customer_id,
	first_name,
	last_name,
	email
FROM
	Customers
WHERE 
	registration_date BETWEEN '2024-06-01' AND '2024-06-30';
    
SELECT -- option 2
	customer_id, 
	first_name,
	last_name,
	email
FROM 
	Customers
WHERE 
	registration_date >= '2024-06-01' 
	AND registration_date <= '2024-06-30';
    
SELECT -- option 3
	customer_id,
	first_name,
	last_name,
	email
FROM 
	Customers
WHERE 
	YEAR(registration_date) = 2024
	AND MONTH(registration_date) = 6;