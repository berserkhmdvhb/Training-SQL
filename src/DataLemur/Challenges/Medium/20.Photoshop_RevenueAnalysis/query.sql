SELECT 
  at1.customer_id,
	SUM(at1.revenue)
FROM adobe_transactions at1
WHERE 
  at1.product <> 'Photoshop'
	AND EXISTS (
		SELECT 1
		FROM adobe_transactions at2
		WHERE 
		  at2.product = 'Photoshop'
			AND
			at1.customer_id = at2.customer_id
		)
GROUP BY customer_id