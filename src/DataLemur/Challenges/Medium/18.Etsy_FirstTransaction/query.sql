WITH userTrans AS (
  SELECT
    transaction_id,
    user_id,
    spend,
    transaction_date,
    DENSE_RANK() OVER(PARTITION BY user_id ORDER BY transaction_date ASC) AS rn
  FROM user_transactions
)
SELECT COUNT(DISTINCT user_id) FROM userTrans
WHERE
  rn = 1
  AND 
  spend > 50;