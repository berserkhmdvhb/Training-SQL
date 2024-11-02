WITH
CTE_product_spend AS
(
  SELECT
    category,
    product,
    user_id,
    spend,
    transaction_date
  FROM product_spend
  WHERE EXTRACT(YEAR FROM transaction_date) = 2022
),
CTE_SumSpend  AS
(
  SELECT
    product,
    SUM(spend) AS sum_spend
  FROM CTE_product_spend
  GROUP BY product
  
),
CTE_category_product AS
(
  SELECT DISTINCT
    product,
    category
  FROM CTE_product_spend
),
CTE_product_orderedBy_spend AS
(
  SELECT 
    cp.category,
    s.product,
    s.sum_spend
  FROM CTE_SumSpend s
  LEFT JOIN CTE_category_product cp
  ON s.product = cp.product
  ORDER BY cp.category, s.sum_spend DESC
),
CTE_product_ranked_category
AS
(
  SELECT
    category,
    product,
    sum_spend,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY sum_spend DESC) AS rowId_spend,
    COUNT(*) OVER (PARTITION BY category) count_spend
  FROM CTE_product_orderedBy_spend
)
SELECT
  category,
  product,
  sum_spend AS "total_spend"
FROM CTE_product_ranked_category
WHERE
  rowId_spend IN (1,2)
