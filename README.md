![SQL](https://img.shields.io/badge/SQL-%20Database%20|%20Queries%20-blue)

# SQL-hackerrank
This repository is dedicated to the SQL challenges from [HackerRank](https://www.hackerrank.com/domains/sql) and [DataLemur](https://www.datalemur.com/) websites.

# Sections

## HackerRank

- [Basic Select](https://github.com/berserkhmdvhb/Training-SQL/blob/main/src/HackerRank/basic-select.md)
- [Advanced Select](https://github.com/berserkhmdvhb/Training-SQL/blob/main/src/HackerRank/advanced-select.md)
- [Aggregation](https://github.com/berserkhmdvhb/Training-SQL/blob/main/src/HackerRank/aggregation.md)
- [Basic Join](https://github.com/berserkhmdvhb/Training-SQL/blob/main/src/HackerRank/basic-join.md)

## DataLemur
- [Challenges - Level Medium](src/DataLemur/Challenges/Medium)


### Examples of self-join and left-join

Suppose we have a `identities` table that has employees information (id, name, email, etc). There is also a column named `manager_id` which is same format as `id`.
We are interested in having both employee info, and complete manager info (manager_id, manager_name, manager_email) in same query:

**Injecting Manager Information**
```
SELECT
    E.emp_id,
    E.emp_name,
    E.emp_mail,
    M.emp_id AS manager_id,
    M.emp_name AS manager_name,
    M.emp_mail AS manager_email
FROM
    identiteies E
LEFT JOIN
    identiteies M
    ON E.emp_manager_id = M.emp_id;
```

**Fill view using a superset table**

Imagine employee information are in table `identiteies` and we have a subset view of it in `vm_employees`. This view has a column `manager_id`, and we need more manager information (name, mail, etc), so we need to join view with table. But, there are some `manager_id` in the view for which there is no correspnding `emp_id` in the same view (meaning that the manager isn't included as a employee in the view), so in order not to miss manager information for these rows, we need the join with the full table `identities`:

 ```
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
    identiteies m
    ON v.emp_manager_id = m.emp_id;
```

**Find Unmatching Rows**

```
SELECT o.*
FROM ods_table o
LEFT JOIN keys_lookup k
    ON o.key = k.key
WHERE k.key IS NULL;
```

If instead of condition `k.key IS NULL`, we put `o.key IS NULL`, it returns rows that actually have `NULL` values in table `ods_table`.
But this condition returns rows of ods_table for which there is no match in table `keys_lookup`.


**

