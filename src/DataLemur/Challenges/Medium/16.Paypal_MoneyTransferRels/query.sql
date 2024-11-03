WITH 
doublePairs AS
(
  SELECT  
    payer_id,
    recipient_id,
    ARRAY[payer_id, recipient_id] pair_a,
    ARRAY[recipient_id, payer_id] pair_b
  FROM payments
), 
uniqueRelsOrdered AS
(
  SELECT
    dp.pair_a,
    dp.pair_b
  FROM doublePairs dp
  WHERE EXISTS (SELECT 1 FROM doublePairs dp2 WHERE dp.pair_a = dp2.pair_b)
  OR EXISTS (SELECT 1 FROM doublePairs dp2 WHERE dp.pair_b = dp2.pair_a)
),
orderedPairs AS 
(
  SELECT DISTINCT ARRAY[
          LEAST(pair_a[1], pair_a[2]),
          GREATEST(pair_a[1], pair_a[2])
      ] AS orderedPair FROM uniqueRelsOrdered 
)
SELECT COUNT(*) FROM orderedPairs