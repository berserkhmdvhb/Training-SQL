# 🧠 Advanced SQL Join Scenarios: Real-World Use Cases

This tutorial covers advanced SQL join patterns derived from real-world business and data engineering use cases. Each example includes a description, practical scenario, and optimized SQL query.

---

## 1. Injecting Manager Information (Self-Join)

Suppose we have an `identities` table that stores employee details (`emp_id`, `emp_name`, `emp_mail`, etc.). Each employee may have a `emp_manager_id` referencing another employee.

We want to include each employee’s own details along with their manager’s name and email:

```sql
SELECT
    e.emp_id,
    e.emp_name,
    e.emp_mail,
    m.emp_id AS manager_id,
    m.emp_name AS manager_name,
    m.emp_mail AS manager_email
FROM
    identities e
LEFT JOIN
    identities m
    ON e.emp_manager_id = m.emp_id;
```

---

## 2. Join a View with a Superset Table (Partial Coverage Case)

- `identities`: full table of employees
- `vw_employees`: view containing a filtered subset (e.g., active employees)
- Some `emp_manager_id`s in the view refer to managers not present in the view

Join the view with the full table to retrieve missing manager details:

```sql
SELECT
    v.emp_id,
    v.emp_name,
    v.emp_mail,
    v.emp_manager_id,
    m.emp_name AS manager_name,
    m.emp_mail AS manager_email
FROM
    vw_employees v
LEFT JOIN
    identities m
    ON v.emp_manager_id = m.emp_id;
```

---

## 3. Find Unmatched Rows (Anti-Join Pattern)

Return rows in `ods_table` that have no match in `keys_lookup`:

```sql
SELECT o.*
FROM ods_table o
LEFT JOIN keys_lookup k
    ON o.key = k.key
WHERE k.key IS NULL;
```

📌 `o.key IS NULL` would instead return rows where the key itself is NULL in the source table — not the same thing.

---

## 4. Capture Missing History (CDC + Anti-Join)

Use case: populate `DatelessAccounts` with rows from `identities` where `changedate IS NULL` **and** they don’t already exist in the destination.

```sql
WITH datelessaccs AS (
    SELECT id
    FROM identities
    WHERE changedate IS NULL
),
cdc AS (
    SELECT v.id, GETDATE() AS insertdate
    FROM datelessaccs v
    LEFT JOIN DatelessAccounts t ON v.id = t.id
    WHERE t.id IS NULL
)
-- INSERT INTO DatelessAccounts (id, insertdate)
-- SELECT * FROM cdc;
```

---

## 5. Hierarchical Join (Multi-Level Reporting)

Build a 2-level hierarchy: employee → manager → senior manager.

```sql
SELECT
    e.emp_name AS employee,
    m.emp_name AS manager,
    sm.emp_name AS senior_manager
FROM
    identities e
LEFT JOIN identities m ON e.emp_manager_id = m.emp_id
LEFT JOIN identities sm ON m.emp_manager_id = sm.emp_id;
```

---

## 6. Detect Duplicate Join Results (Exploding Rows)

Sometimes joins unintentionally multiply rows. Use these two methods to detect it.

### Approach 1: Aggregate and Filter

```sql
SELECT e.emp_id, COUNT(*) AS match_count
FROM identities e
JOIN payrolls p ON e.emp_id = p.emp_id
GROUP BY e.emp_id
HAVING COUNT(*) > 1;
```

### Approach 2: Window Functions

```sql
WITH duplicates AS (
    SELECT
        e.emp_id,
        COUNT(*) OVER (PARTITION BY e.emp_id) AS match_count,
        ROW_NUMBER() OVER (PARTITION BY e.emp_id ORDER BY p.pay_date DESC) AS rn
    FROM identities e
    JOIN payrolls p ON e.emp_id = p.emp_id
)
SELECT *
FROM duplicates
WHERE match_count > 1;
```

---

## 7. Get Latest Record per Group (CDC / Audit Log)

Use `ROW_NUMBER()` to get the most recent update per employee:

```sql
WITH ranked_changes AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY changedate DESC) AS rn
    FROM identities_audit
)
SELECT *
FROM ranked_changes
WHERE rn = 1;
```

---
---

## 8. Join with Multiple Conditions (Composite Join Key)

Temporal join based on product and time validity:

```sql
SELECT s.*, p.price
FROM sales s
JOIN prices p
  ON s.product_id = p.product_id
 AND s.sale_date BETWEEN p.valid_from AND p.valid_to;
```

📌 Use case: Time-valid prices, slowly changing dimensions (SCD), etc.

---

## 9. Semi-Join Using EXISTS (Efficient Filtering)

Use `EXISTS` to efficiently check for existence without bringing in duplicate rows:

```sql
SELECT *
FROM orders o
WHERE EXISTS (
    SELECT 1
    FROM approved_customers a
    WHERE o.customer_id = a.customer_id
);
```

✅ Improves performance compared to `IN` or `LEFT JOIN ... IS NOT NULL`.

---

## 10. Join with NULL-Safe Conditions (`COALESCE`)

Match rows where NULLs should be treated as equal using `COALESCE`:

```sql
SELECT *
FROM table_a a
JOIN table_b b
  ON COALESCE(a.col1, 'default') = COALESCE(b.col1, 'default');
```

⚠️ Use with care in large joins — may impact index usage.

---

## 11. Self-Anti-Join for Top N per Group

Get the latest **N versions** of records per entity (e.g., last 3 updates):

```sql
WITH ranked_versions AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY version_date DESC) AS rn
    FROM user_versions
)
SELECT *
FROM ranked_versions
WHERE rn <= 3;
```

---

## 12. Detect Mismatches (Full Outer Join + NULL-Safe Comparison)

Identify differences between staging and production tables:

```sql
SELECT *
FROM staging_data s
FULL OUTER JOIN prod_data p
  ON s.id = p.id
WHERE s.col1 IS DISTINCT FROM p.col1;
```

✅ `IS DISTINCT FROM` handles NULLs safely (unlike `<>` or `!=`).

---

## 13. Join with Aggregated Subquery

Join a dimension table with an aggregate metric per entity:

```sql
SELECT c.customer_id, c.name, sp.total_spent
FROM customers c
LEFT JOIN (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payments
    GROUP BY customer_id
) sp ON c.customer_id = sp.customer_id;
```

💡 Good for reporting KPIs and performance dashboards.

---
