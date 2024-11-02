WITH transactions_ext AS (
  SELECT
    user_id,
    amount,
    transaction_date AS td,
    LAG(transaction_date, 1) OVER(PARTITION BY user_id ORDER BY transaction_date) AS prev_date_1,
    LAG(transaction_date, 2) OVER(PARTITION BY user_id ORDER BY transaction_date) AS prev_date_2
  FROM transactions
), 
users_sprees AS (
  SELECT DISTINCT user_id
  FROM transactions_ext
  WHERE 
    td = prev_date_1 + INTERVAL '1 day'
    AND
    prev_date_1 = prev_date_2 + INTERVAL '1 day'
)
SELECT *
FROM users_sprees;
