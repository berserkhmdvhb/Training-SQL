WITH 
user_actions_FilterDate AS
(
  SELECT 
    user_id,
    EXTRACT(MONTH FROM event_date) as "Month"
  FROM user_actions
  WHERE 
    EXTRACT(YEAR FROM event_date) = 2022
    AND
    EXTRACT(MONTH FROM event_date) IN (6,7)
),
user_actions_active  AS
(
  SELECT
    ua.user_id,
    ua."Month"
  FROM
    user_actions_FilterDate ua
  WHERE 
    ua."Month" = 7
  AND EXISTS 
  (
    SELECT 1 FROM user_actions_FilterDate ua2
    WHERE 
      ua2."Month" = 6
    AND
      ua.user_id = ua2.user_id
  )
)
SELECT DISTINCT
  "Month",
  COUNT(DISTINCT ua.user_id)
FROM user_actions_active ua
GROUP BY "Month"
;
