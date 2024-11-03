WITH 
placeRev AS
(
  SELECT
    p.place_id,
    p.place_name,
    p.place_category,
    r.content_id,
    r.content_tag
  FROM place_info p
  JOIN maps_ugc_review r ON p.place_id = r.place_id
),
offTopics AS 
(
  SELECT 
    place_category,
    COUNT(*) AS count_tag
  FROM placeRev
  WHERE content_tag = 'Off-topic'
  GROUP BY place_category
  ORDER BY COUNT(*) DESC
 )
SELECT
  place_category
FROM offTopics
WHERE count_tag = (SELECT MAX(count_tag) FROM offTopics)
ORDER BY place_category ASC