-- Based on order of appearance in table
WITH CTE_with_row_order AS
(
  SELECT
    card_name,
    issued_amount,
    issue_month,
    issue_year,
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS row_order
  FROM monthly_cards_issued
),
CTE_ranked_cards AS
(
  SELECT
    card_name,
    issued_amount,
    issue_month,
    issue_year,
    ROW_NUMBER() OVER (PARTITION BY card_name ORDER BY row_order) AS rn,
    row_order
  FROM CTE_with_row_order
)
SELECT
  card_name,
  issued_amount,
  issue_month,
  issue_year
FROM CTE_ranked_cards
WHERE rn = 1
ORDER BY row_order;

-- Based on issue_year

WITH CTE_with_row_order AS
(
  SELECT
    card_name,
    issued_amount,
    issue_month,
    issue_year,
    ROW_NUMBER() OVER (PARTITION BY card_name ORDER BY issue_year) AS rn
    FROM monthly_cards_issued
)
SELECT
  card_name,
  issued_amount
FROM CTE_with_row_order
WHERE rn = 1
ORDER BY card_name DESC
