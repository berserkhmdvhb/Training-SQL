WITH users_ranked AS (
    SELECT
        session_id,
        user_id,
        session_type,
        duration,
        start_date,
        ROW_NUMBER() OVER(PARTITION BY session_type ORDER BY duration DESC) AS rn_order
    FROM sessions
),
session_type_order AS (
    SELECT
        session_type,
        MAX(duration) AS max_duration
    FROM users_ranked
    GROUP BY session_type
),
ordered_sessions AS (
    SELECT
        u.user_id,
        u.session_type,
        u.duration,
        u.rn_order AS ranking,
        sto.max_duration,
        ROW_NUMBER() OVER (ORDER BY sto.max_duration DESC, u.session_type, u.rn_order) AS session_type_rank
    FROM users_ranked u
    JOIN session_type_order sto ON u.session_type = sto.session_type
)
SELECT 
    user_id,
    session_type,
    ranking,
    duration
FROM ordered_sessions
ORDER BY session_type_rank, ranking;