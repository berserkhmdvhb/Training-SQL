CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT *
FROM crosstab(
    'SELECT user_id, email_type, email FROM users ORDER BY 1, 2'
) AS pivot_table(user_id INT, personal TEXT, business TEXT, recovery TEXT);
