WITH phone_calls_CTE AS
(
SELECT 
c.caller_id,
c.receiver_id,
c.call_time,
i.country_id AS caller_country_id,
ii.country_id AS receiver_country_id
FROM phone_calls c
INNER JOIN phone_info i
ON c.caller_id = i.caller_id
INNER JOIN phone_info ii
ON c.receiver_id = ii.caller_id
),
COUNT_International
AS (
SELECT COUNT(*) AS CI  FROM phone_calls_CTE
WHERE caller_country_id <> receiver_country_id
),
COUNT_Total AS 
(
SELECT COUNT(*) AS CT FROM phone_calls
)
SELECT 
     ROUND((CAST(CI AS NUMERIC) / CT) * 100, 1) AS international_calls_pct
FROM 
    COUNT_International, COUNT_Total; 
;
