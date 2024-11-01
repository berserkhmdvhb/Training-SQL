WITH songs_WeeklyAgg AS (
  SELECT
    user_id,
    song_id,
    COUNT(song_id) AS song_plays
  FROM songs_weekly
  WHERE listen_time < CAST('2022-08-04 23:59:59' AS TIMESTAMP)
  GROUP BY 
    user_id,
    song_id
  --ORDER BY h.history_id
), 
songs_GranularityMatch AS (
  SELECT
    user_id,
    song_id,
    song_plays
  FROM songs_WeeklyAgg
  
  UNION ALL 
  
  SELECT
    user_id,
    song_id,
    song_plays
  FROM songs_history
),
songs_CummCount AS (
  SELECT
    user_id,
    song_id,
    SUM(song_plays) OVER (PARTITION BY user_id,song_id) AS song_count
  FROM songs_GranularityMatch
)
SELECT DISTINCT *
FROM songs_CummCount 
ORDER BY song_count DESC