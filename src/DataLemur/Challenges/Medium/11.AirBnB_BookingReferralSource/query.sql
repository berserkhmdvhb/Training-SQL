WITH BookingsExt AS 
(
  SELECT
    b.booking_id,
    b.user_id,
    b.booking_date,
    a.channel,
    ROW_NUMBER() OVER(PARTITION BY b.user_id ORDER BY b.booking_date ASC) AS RN,
    COUNT(*) OVER(PARTITION BY b.user_id ORDER BY b.booking_date ASC) AS COUNT_B
  FROM bookings b
  JOIN booking_attribution a
  ON a.booking_id = b.booking_id
),
BookingsFirst AS
(
  SELECT *
  FROM BookingsExt
  WHERE RN = 1 
),
COUNT_BookingsFirst AS 
(
  SELECT
    COUNT(*) AS COUNT_FB
  FROM BookingsFirst
),
COUNT_Channels AS 
(
  SELECT
    channel,
    COUNT(*) AS COUNT_C
  FROM BookingsFirst
  GROUP BY channel
),
PCT_Channels AS 
(
  SELECT 
    channel,
    ROUND((CAST(COUNT_C AS NUMERIC) / COUNT_FB) * 100.0, 0) AS first_booking_pct
  FROM 
  COUNT_Channels,COUNT_BookingsFirst
)
SELECT
  *
FROM
PCT_Channels
WHERE channel IS NOT NULL
ORDER BY first_booking_pct DESC
LIMIT 1;
