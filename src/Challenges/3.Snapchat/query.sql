WITH combined_times AS (
  SELECT 
    user_id,
    SUM(CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END) AS total_time_send,
    SUM(CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END) AS total_time_open
  FROM activities
  WHERE activity_type IN ('send', 'open')  -- Filter the relevant activity types
  GROUP BY user_id
),
breakdown AS (
  SELECT
    user_id,
    (total_time_send / (total_time_send + total_time_open)) * 100.0 AS send_perc,
    (total_time_open / (total_time_open + total_time_send)) * 100.0 AS open_perc
  FROM combined_times
  WHERE total_time_send + total_time_open > 0  -- Avoid division by zero
),
breakdown_rounded AS (
  SELECT 
    user_id,
    ROUND(send_perc, 2) AS send_perc,
    ROUND(open_perc, 2) AS open_perc
  FROM breakdown
),
breakdown_agegrouped AS (
  SELECT
    b.user_id,
    a.age_bucket,
    b.send_perc,
    b.open_perc
  FROM breakdown_rounded b
  INNER JOIN age_breakdown a
  ON b.user_id = a.user_id
)
SELECT
  age_bucket,
  SUM(send_perc) AS total_send_perc,
  SUM(open_perc) AS total_open_perc
FROM breakdown_agegrouped
GROUP BY age_bucket
;
