WITH IndexedTransactions AS (
SELECT 
    user_id,
    spend,
    transaction_date,
    ROW_NUMBER() OVER (
        PARTITION BY user_id 
        ORDER BY transaction_date
    ) AS row_num,
    COUNT(*) OVER (PARTITION BY user_id) AS row_count
FROM transactions
)
SELECT 
user_id,
spend,
transaction_date
FROM IndexedTransactions
WHERE
  row_num = 3
  AND
  row_count >= 3
  

