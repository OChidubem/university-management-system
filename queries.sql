-- ============================================================
--  University Research Management System - SQL Queries
--  CSCI 411 | Chidubem Okoye & Praptika Bajracharya
-- ============================================================
USE urms;

-- ─────────────────────────────────────────────────────────────
-- QUERY 1: Total awarded funding per department
-- ─────────────────────────────────────────────────────────────
SELECT
    d.department_name,
    COUNT(DISTINCT rp.project_id)          AS total_projects,
    COUNT(DISTINCT g.grant_id)             AS total_grants,
    FORMAT(SUM(g.award_amount), 2)         AS total_funding_usd
FROM Department d
JOIN ResearchProject rp ON rp.department_id = d.department_id
JOIN ProjectGrant    g  ON g.project_id     = rp.project_id
WHERE g.grant_status = 'Awarded'
GROUP BY d.department_id, d.department_name
ORDER BY SUM(g.award_amount) DESC;

/*
Expected Output:
+------------------------------+----------------+--------------+--------------------+
| department_name              | total_projects | total_grants | total_funding_usd  |
+------------------------------+----------------+--------------+--------------------+
| Computer Science             |              3 |            6 | 1,300,000.00       |
| Biology                      |              1 |            1 |   320,000.00       |
| Mathematics                  |              1 |            1 |    25,000.00       |
+------------------------------+----------------+--------------+--------------------+
3 rows in set
*/


-- ─────────────────────────────────────────────────────────────
-- QUERY 2: Remaining budget per active grant
-- ─────────────────────────────────────────────────────────────
SELECT
    g.grant_id,
    g.grant_title,
    sp.sponsor_name,
    FORMAT(g.award_amount, 2)                              AS award_amount,
    FORMAT(COALESCE(SUM(e.amount), 0), 2)                  AS total_spent,
    FORMAT(g.award_amount - COALESCE(SUM(e.amount), 0), 2) AS remaining_budget
FROM ProjectGrant g
JOIN Sponsor sp   ON sp.sponsor_id = g.sponsor_id
LEFT JOIN Expense e ON e.grant_id  = g.grant_id
WHERE g.grant_status = 'Awarded'
GROUP BY g.grant_id, g.grant_title, sp.sponsor_name, g.award_amount
ORDER BY (g.award_amount - COALESCE(SUM(e.amount), 0)) ASC;

/*
Expected Output:
+----------+------------------------------------------+---------------------------------+--------------+-------------+------------------+
| grant_id | grant_title                              | sponsor_name                    | award_amount | total_spent  | remaining_budget |
+----------+------------------------------------------+---------------------------------+--------------+-------------+------------------+
|        1 | NSF Cybersecurity Initiative 2023        | National Science Foundation     | 450,000.00   | 121,200.00  | 328,800.00       |
|        2 | NIH Plant Immunity CRISPR Grant          | NIH - Nat. Institutes of Health | 320,000.00   |  78,000.00  | 242,000.00       |
|        4 | NSF Privacy-Preserving ML Grant          | National Science Foundation     | 500,000.00   |  95,500.00  | 404,500.00       |
|        5 | Gates Foundation Drug Discovery Grant    | Bill & Melinda Gates Foundation | 750,000.00   |  53,500.00  | 696,500.00       |
|        3 | Google AI Security Research Award        | Google Research                 | 200,000.00   |  25,000.00  | 175,000.00       |
|        6 | Internal Climate Modeling Seed Grant     | University Internal Fund        |  25,000.00   |   3,200.00  |  21,800.00       |
|        8 | Google Cloud Healthcare ML Support       | Google Research                 | 150,000.00   |       0.00  | 150,000.00       |
+----------+------------------------------------------+---------------------------------+--------------+-------------+------------------+
7 rows in set
*/


-- ─────────────────────────────────────────────────────────────
-- QUERY 3: Publications per faculty member (via project roles)
-- ─────────────────────────────────────────────────────────────
SELECT
    CONCAT(f.first_name, ' ', f.last_name) AS faculty_name,
    d.department_name,
    COUNT(p.publication_id)                AS publication_count
FROM Faculty f
JOIN Department  d  ON d.department_id = f.department_id
JOIN ProjectRole pr ON pr.person_type  = 'Faculty'
                   AND pr.person_id    = f.faculty_id
JOIN Publication p  ON p.project_id   = pr.project_id
GROUP BY f.faculty_id, faculty_name, d.department_name
ORDER BY publication_count DESC;

/*
Expected Output:
+----------------+--------------------------+-------------------+
| faculty_name   | department_name          | publication_count |
+----------------+--------------------------+-------------------+
| Aiden Zhao     | Computer Science         |                 3 |
| Maria Reyes    | Computer Science         |                 2 |
| Samuel Okafor  | Biology                  |                 1 |
| Priya Nair     | Chemistry                |                 2 |
| James Chen     | Electrical Engineering   |                 1 |
+----------------+--------------------------+-------------------+
5 rows in set
*/


-- ─────────────────────────────────────────────────────────────
-- QUERY 4: Top sponsors by total awarded amount
-- ─────────────────────────────────────────────────────────────
SELECT
    sp.sponsor_name,
    sp.sponsor_type,
    COUNT(g.grant_id)              AS grants_awarded,
    FORMAT(SUM(g.award_amount), 2) AS total_awarded
FROM Sponsor sp
JOIN ProjectGrant g ON g.sponsor_id   = sp.sponsor_id
                   AND g.grant_status IN ('Awarded','Closed')
GROUP BY sp.sponsor_id, sp.sponsor_name, sp.sponsor_type
ORDER BY SUM(g.award_amount) DESC;

/*
Expected Output:
+----------------------------------+-------------+----------------+----------------+
| sponsor_name                     | sponsor_type| grants_awarded | total_awarded  |
+----------------------------------+-------------+----------------+----------------+
| Bill & Melinda Gates Foundation  | Nonprofit   |              1 | 750,000.00     |
| National Science Foundation      | Government  |              3 | 1,225,000.00   |
| Google Research                  | Industry    |              2 | 350,000.00     |
| NIH - National Institutes of Health | Government |            1 | 320,000.00     |
| University Internal Fund         | Internal    |              1 |  25,000.00     |
+----------------------------------+-------------+----------------+----------------+
5 rows in set
*/


-- ─────────────────────────────────────────────────────────────
-- QUERY 5: Projects with NO publications (overdue check)
-- ─────────────────────────────────────────────────────────────
SELECT
    rp.project_id,
    rp.project_title,
    rp.status,
    rp.start_date,
    DATEDIFF(CURDATE(), rp.start_date) AS days_active
FROM ResearchProject rp
LEFT JOIN Publication p ON p.project_id = rp.project_id
WHERE p.publication_id IS NULL
  AND rp.status = 'Active'
ORDER BY days_active DESC;

/*
Expected Output:
+------------+------------------------------------------+--------+------------+-------------+
| project_id | project_title                            | status | start_date | days_active |
+------------+------------------------------------------+--------+------------+-------------+
|          4 | Federated Learning for Healthcare Privacy| Active | 2024-01-20 |         428 |
+------------+------------------------------------------+--------+------------+-------------+
1 row in set
*/


-- ─────────────────────────────────────────────────────────────
-- QUERY 6: All projects a specific student is working on
-- ─────────────────────────────────────────────────────────────
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    rp.project_title,
    pr.role_name,
    pr.date_joined,
    rp.status
FROM Student s
JOIN ProjectRole     pr ON pr.person_type = 'Student'
                       AND pr.person_id   = s.student_id
JOIN ResearchProject rp ON rp.project_id = pr.project_id
WHERE s.student_id = 1;   -- Carlos Mendez

/*
Expected Output:
+--------------+----------------------------------------+--------------------+-------------+--------+
| student_name | project_title                          | role_name          | date_joined | status |
+--------------+----------------------------------------+--------------------+-------------+--------+
| Carlos Mendez| ML-Based Intrusion Detection System    | Research Assistant | 2023-09-01  | Active |
| Carlos Mendez| Graph Neural Networks for Drug Discovery| Data Analyst       | 2023-05-10  | Active |
+--------------+----------------------------------------+--------------------+-------------+--------+
2 rows in set
*/


-- ─────────────────────────────────────────────────────────────
-- VIEW 1: Department research summary
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW dept_research_summary AS
SELECT
    d.department_id,
    d.department_name,
    COUNT(DISTINCT rp.project_id)   AS project_count,
    COUNT(DISTINCT g.grant_id)      AS grant_count,
    COALESCE(SUM(g.award_amount),0) AS total_funding,
    COUNT(DISTINCT p.publication_id)AS publication_count
FROM Department d
LEFT JOIN ResearchProject rp ON rp.department_id = d.department_id
LEFT JOIN ProjectGrant    g  ON g.project_id     = rp.project_id
                             AND g.grant_status  = 'Awarded'
LEFT JOIN Publication     p  ON p.project_id     = rp.project_id
GROUP BY d.department_id, d.department_name;


-- ─────────────────────────────────────────────────────────────
-- VIEW 2: Active projects with remaining budget
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW active_projects_with_budget AS
SELECT
    rp.project_id,
    rp.project_title,
    d.department_name,
    g.grant_title,
    g.award_amount,
    COALESCE(SUM(e.amount), 0)                   AS total_spent,
    g.award_amount - COALESCE(SUM(e.amount), 0)  AS remaining_budget
FROM ResearchProject rp
JOIN Department    d  ON d.department_id = rp.department_id
JOIN ProjectGrant  g  ON g.project_id   = rp.project_id
LEFT JOIN Expense  e  ON e.grant_id     = g.grant_id
WHERE rp.status     = 'Active'
  AND g.grant_status = 'Awarded'
GROUP BY rp.project_id, rp.project_title, d.department_name,
         g.grant_id, g.grant_title, g.award_amount;
