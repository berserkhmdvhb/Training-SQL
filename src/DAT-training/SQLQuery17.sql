SELECT CONCAT(customers.firstname, ' ', customers.lastname) AS fullName, 
basket_orders.order_date, customers.address, basketPrice.basket_id, basket_price, basket_name, 
basket_price * 2 + 3 AS recall,
CASE 
  WHEN basket_price <= 10 
    THEN 'Jeremy Castle'
  ELSE 'Kate Ryan'
  END AS transport_employee
FROM 
(SELECT basket_id, SUM(fruits.price_dollar * fruit_basket_mapping.quantity) AS basket_price
FROM fruits
    JOIN fruit_basket_mapping ON fruits.fruit_id = fruit_basket_mapping.fruit_id 
	GROUP BY fruit_basket_mapping.basket_id
) AS basketPrice
JOIN basket_orders ON basket_orders.basket_id = basketPrice.basket_id
JOIN customers ON customers.customer_id = basket_orders.customer_id
JOIN baskets ON baskets.basket_id = basket_orders.basket_id
WHERE (YEAR(basket_orders.order_date) = 2022) AND (MONTH(basket_orders.order_date) = 9) AND (DAY(basket_orders.order_date) BETWEEN 15 AND 30)