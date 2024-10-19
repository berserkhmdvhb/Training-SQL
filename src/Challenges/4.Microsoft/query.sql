WITH customer_contracts_extended AS 
(
SELECT
  c.customer_id,
  c.product_id,
  p.product_category,
  p.product_name
FROM customer_contracts c
INNER JOIN products p
ON c.product_id = p.product_id
)

SELECT
  customer_id
FROM customer_contracts_extended
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category) = (SELECT COUNT(DISTINCT product_category) FROM products)