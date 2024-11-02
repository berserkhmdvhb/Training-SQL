WITH RECURSIVE product_indexed
AS (
	SELECT product_id,
		category,
		name,
		category AS filled_category,
		ROW_NUMBER() OVER (
			ORDER BY product_id
			) AS row_num
	FROM products
	),
recursive_fill
AS (
	SELECT product_id,
		COALESCE(filled_category, LAG(filled_category) OVER (
				ORDER BY row_num
				)) AS category,
		name,
		row_num
	FROM product_indexed
	WHERE row_num = 1
	
	UNION ALL
	
	SELECT pidx.product_id,
		COALESCE(pidx.filled_category, rf.category) AS category,
		pidx.name,
		pidx.row_num
	FROM product_indexed pidx
	JOIN recursive_fill rf ON pidx.row_num = rf.row_num + 1
	)
SELECT product_id,
	category,
	name
FROM recursive_fill
ORDER BY product_id;