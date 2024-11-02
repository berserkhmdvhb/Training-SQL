WITH measurements_extended AS
(
  SELECT 
    measurement_id,
    measurement_value,
    measurement_time,
    day,
    CAST(measurement_time AS DATE) AS measurement_day
  FROM 
  measurements
),
measurements_ordered AS
(
  SELECT
    measurement_id,
    measurement_value,
    measurement_time,
    day,
    measurement_day,
    ROW_NUMBER() OVER (PARTITION BY measurement_day ORDER BY measurement_time) AS "measurement_num"
  FROM measurements_extended
)
SELECT 
  measurement_day,
  SUM(CASE WHEN mod(measurement_num, 2) <> 0 THEN measurement_value ELSE 0 END) AS odd_sum,
  SUM(CASE WHEN mod(measurement_num, 2) = 0 THEN measurement_value ELSE 0 END) AS even_sum
FROM  measurements_ordered
GROUP BY measurement_day

