SELECT YEAR(sale.sale_date) AS saleYear, client.client_firstname + ' ' + client.client_lastname AS names, SUM(sale.sale_total) AS totalSale 
FROM sale JOIN 
client ON
sale.client_id = client.client_id
WHERE sale.sale_type = 'S'
GROUP BY 
 GROUPING SETS 
 (
	(client.client_firstname + ' ' + client.client_lastname, YEAR(sale.sale_date)),
	client.client_firstname + ' ' + client.client_lastname,
	YEAR(sale.sale_date)
 )

ORDER BY client.client_firstname + ' ' + client.client_lastname