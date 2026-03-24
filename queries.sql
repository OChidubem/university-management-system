-- ============================================================
-- queries.sql — Analytical SQL Queries
-- URMS | CSCI 411 | Spring 2025
-- ============================================================
USE urms;

-- ── Query 1: Total Awarded Funding per Department ───────────
SELECT
    d.department_name,
    COUNT(DISTINCT p.project_id)   AS total_projects,
    SUM(g.award_amount)            AS total_funding
FROM Department d
JOIN ResearchProject p USING (department_id)
JOIN `Grant` g         USING (project_id)
WHERE g.grant_status = 'Awarded'
GROUP BY d.department_id, d.department_name
ORDER BY total_funding DESC;

-- ── Query 2: Remaining Budget per Awarded Grant ─────────────
SELECT
    g.grant_title,
    g.award_amount,
    COALESCE(SUM(e.amount), 0)                     AS total_spent,
    g.award_amount - COALESCE(SUM(e.amount), 0)    AS remaining_budget
FROM `Grant` g
LEFT JOIN Expense e USING (grant_id)
WHERE g.grant_status = 'Awarded'
GROUP BY g.grant_id, g.grant_title, g.award_amount
ORDER BY remaining_budget ASC;

-- ── Query 3: Publications per Faculty Member ────────────────
SELECT
    CONCAT(f.first_name, ' ', f.last_name) AS faculty_name,
    d.department_name,
    COUNT(DISTINCT pub.publication_id)     AS publication_count
FROM Faculty f
JOIN Department d      ON f.department_id   = d.department_id
JOIN ProjectRole pr    ON pr.person_id      = f.faculty_id
    AND pr.person_type = 'Faculty'
JOIN Publication pub   ON pub.project_id    = pr.project_id
GROUP BY f.faculty_id, faculty_name, d.department_name
ORDER BY publication_count DESC;

-- ── Query 4: Overdue Projects (past end_date but still Active)
SELECT
    p.project_title,
    d.department_name,
    p.end_date,
    DATEDIFF(CURDATE(), p.end_date) AS days_overdue
FROM ResearchProject p
JOIN Department d ON p.department_id = d.department_id
WHERE p.end_date < CURDATE()
  AND p.status   = 'Active'
ORDER BY days_overdue DESC;

-- ── Query 5: Top Sponsors by Total Awarded Amount ───────────
SELECT
    s.sponsor_name,
    s.sponsor_type,
    COUNT(DISTINCT g.grant_id)    AS grants_awarded,
    SUM(g.award_amount)           AS total_awarded
FROM Sponsor s
JOIN `Grant` g ON s.sponsor_id = g.sponsor_id
WHERE g.grant_status = 'Awarded'
GROUP BY s.sponsor_id, s.sponsor_name, s.sponsor_type
ORDER BY total_awarded DESC;

-- ── Query 6: Departments Ranked by Publication Count ────────
SELECT
    d.department_name,
    COUNT(DISTINCT pub.publication_id) AS publication_count,
    COUNT(DISTINCT p.project_id)       AS active_projects
FROM Department d
LEFT JOIN ResearchProject p ON d.department_id = p.department_id
LEFT JOIN Publication pub   ON p.project_id    = pub.project_id
GROUP BY d.department_id, d.department_name
ORDER BY publication_count DESC;

-- ── Query 7: Student Involvement Summary ────────────────────
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.major,
    s.graduation_year,
    COUNT(DISTINCT pr.project_id)          AS projects_involved,
    GROUP_CONCAT(DISTINCT rp.project_title
        ORDER BY rp.project_title
        SEPARATOR ' | ')                   AS project_titles
FROM Student s
JOIN ProjectRole pr      ON pr.person_id   = s.student_id
    AND pr.person_type = 'Student'
JOIN ResearchProject rp  ON rp.project_id  = pr.project_id
GROUP BY s.student_id, student_name, s.major, s.graduation_year
ORDER BY projects_involved DESC;

-- ── Query 8: Grants Approaching Budget Threshold (>80%) ─────
SELECT
    g.grant_title,
    g.award_amount,
    COALESCE(SUM(e.amount), 0)                              AS total_spent,
    ROUND(COALESCE(SUM(e.amount), 0) / g.award_amount * 100, 1) AS pct_spent,
    g.award_amount - COALESCE(SUM(e.amount), 0)            AS remaining
FROM `Grant` g
LEFT JOIN Expense e ON g.grant_id = e.grant_id
WHERE g.grant_status = 'Awarded'
GROUP BY g.grant_id, g.grant_title, g.award_amount
HAVING pct_spent >= 50
ORDER BY pct_spent DESC;
