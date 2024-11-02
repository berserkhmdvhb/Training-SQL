WITH prodstrans AS (
  SELECT 
    T.transaction_id,
    T.user_id,
    T.transaction_date,
    T.product_id,
    P.product_name
  FROM transactions T
  JOIN products P ON
  T.product_id = P.product_id
),
prodstrans_idx AS (
  SELECT
    user_id,
    transaction_date,
    ARRAY_AGG(DISTINCT product_name) AS prodsNames,
    ARRAY_AGG(DISTINCT product_id) AS prodsIds 
  FROM prodstrans
    GROUP BY 
      user_id, transaction_date
),
prodstrans_filtered AS 
(
  SELECT
    user_id,
    transaction_date,
    prodsNames,
    prodsIds,
    (SELECT COUNT(*) FROM UNNEST(prodsNames)) AS count_prodsNames
  FROM prodstrans_idx
  WHERE 
    (SELECT COUNT(*) FROM UNNEST(prodsNames)) > 1
  ORDER BY count_prodsnames DESC
)
SELECT DISTINCT prodsids AS combination
FROM prodstrans_filtered