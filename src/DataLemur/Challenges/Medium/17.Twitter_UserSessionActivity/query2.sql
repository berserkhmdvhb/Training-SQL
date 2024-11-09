WITH filtered_sessions AS (
    SELECT
        user_id,
        session_type,
        SUM(duration) AS total_duration
    FROM sessions
    WHERE start_date BETWEEN '2022-01-01' AND '2022-02-01'
    GROUP BY user_id, session_type
),
ranked_sessions AS (
    SELECT
        user_id,
        session_type,
        total_duration,
        ROW_NUMBER() OVER (PARTITION BY session_type ORDER BY total_duration DESC) AS ranking
    FROM filtered_sessions
)
SELECT 
    user_id,
    session_type,
    ranking
FROM ranked_sessions
ORDER BY session_type, ranking;