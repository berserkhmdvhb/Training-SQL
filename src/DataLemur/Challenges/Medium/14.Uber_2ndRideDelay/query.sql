WITH rides_idx
AS 
(
	SELECT
	  r.user_id,
		r.ride_id,
		r.ride_date,
		ROW_NUMBER() OVER (PARTITION BY r.user_id ORDER BY r.ride_date ASC) AS ride_order
	FROM rides r
),
inMomentUsers
AS 
(
	SELECT DISTINCT 
	  r.user_id,
	  u.registration_date
	FROM rides_idx r
	JOIN users u
	ON (
	u.user_id = r.user_id
	AND
	CAST(r.ride_date AS DATE) = CAST(u.registration_date AS DATE)
	AND
	r.ride_order = 1
	)
),
inMomentUsersExtended AS 
(
  SELECT
    r.user_id,
    r.ride_id,
    r.ride_date,
    r.ride_order,
    imu.registration_date
  FROM rides_idx r
  JOIN inMomentUsers imu ON r.user_id = imu.user_id
  WHERE r.ride_order = 2
),
DelaysDiff AS
(
  SELECT
    user_id,
    ride_date - registration_date AS Diff
  FROM inMomentUsersExtended
)
SELECT
  ROUND(SUM (Diff)::numeric / (SELECT COUNT(*) FROM DelaysDiff), 2) AS average_delay
FROM DelaysDiff