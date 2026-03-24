-- ============================================================
-- University Research Management System
-- CSCI 411 | Okoye & Bajracharya | Spring 2025
-- schema.sql — Full DDL
-- ============================================================

CREATE DATABASE IF NOT EXISTS urms;
USE urms;

-- 1. Department
CREATE TABLE Department (
    department_id   INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(120) NOT NULL,
    college_name    VARCHAR(120) NOT NULL,
    office_location VARCHAR(80)
);

-- 2. Faculty
CREATE TABLE Faculty (
    faculty_id    INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(60)  NOT NULL,
    last_name     VARCHAR(60)  NOT NULL,
    email         VARCHAR(120) NOT NULL UNIQUE,
    rank          ENUM('Assistant','Associate','Professor') NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id) ON DELETE RESTRICT
);

-- 3. Student
CREATE TABLE Student (
    student_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(60)  NOT NULL,
    last_name       VARCHAR(60)  NOT NULL,
    email           VARCHAR(120) NOT NULL UNIQUE,
    major           VARCHAR(80),
    graduation_year YEAR,
    department_id   INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id) ON DELETE RESTRICT
);

-- 4. ResearchProject
CREATE TABLE ResearchProject (
    project_id    INT AUTO_INCREMENT PRIMARY KEY,
    project_title VARCHAR(200) NOT NULL,
    abstract      TEXT,
    start_date    DATE NOT NULL,
    end_date      DATE,
    status        ENUM('Proposed','Active','Completed','Suspended') NOT NULL DEFAULT 'Proposed',
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id) ON DELETE RESTRICT
);

-- 5. ProjectRole (resolves M:N between projects and people)
CREATE TABLE ProjectRole (
    role_id     INT AUTO_INCREMENT PRIMARY KEY,
    project_id  INT NOT NULL,
    person_type ENUM('Faculty','Student') NOT NULL,
    person_id   INT NOT NULL,
    role_name   ENUM('PI','Co-PI','Research Assistant','Data Analyst','Author','Other') NOT NULL,
    date_joined DATE NOT NULL,
    FOREIGN KEY (project_id) REFERENCES ResearchProject(project_id) ON DELETE CASCADE
);

-- 6. Sponsor
CREATE TABLE Sponsor (
    sponsor_id    INT AUTO_INCREMENT PRIMARY KEY,
    sponsor_name  VARCHAR(150) NOT NULL,
    sponsor_type  ENUM('Government','Industry','Nonprofit','Internal') NOT NULL,
    contact_email VARCHAR(120)
);

-- 7. Grant
CREATE TABLE `Grant` (
    grant_id     INT AUTO_INCREMENT PRIMARY KEY,
    sponsor_id   INT NOT NULL,
    project_id   INT NOT NULL,
    grant_title  VARCHAR(200) NOT NULL,
    award_amount DECIMAL(14,2) NOT NULL,
    award_date   DATE,
    grant_status ENUM('Submitted','Awarded','Rejected','Closed') NOT NULL DEFAULT 'Submitted',
    FOREIGN KEY (sponsor_id) REFERENCES Sponsor(sponsor_id) ON DELETE RESTRICT,
    FOREIGN KEY (project_id) REFERENCES ResearchProject(project_id) ON DELETE RESTRICT
);

-- 8. Expense
CREATE TABLE Expense (
    expense_id  INT AUTO_INCREMENT PRIMARY KEY,
    grant_id    INT NOT NULL,
    expense_date DATE NOT NULL,
    category    ENUM('Equipment','Travel','Personnel','Supplies','Overhead','Other') NOT NULL,
    amount      DECIMAL(12,2) NOT NULL,
    description VARCHAR(300),
    CONSTRAINT chk_expense_positive CHECK (amount > 0),
    FOREIGN KEY (grant_id) REFERENCES `Grant`(grant_id) ON DELETE RESTRICT
);

-- 9. Publication
CREATE TABLE Publication (
    publication_id   INT AUTO_INCREMENT PRIMARY KEY,
    project_id       INT NOT NULL,
    title            VARCHAR(300) NOT NULL,
    publication_type ENUM('Journal','Conference','Poster','Thesis') NOT NULL,
    venue_name       VARCHAR(200),
    publication_date DATE,
    doi_or_url       VARCHAR(300),
    FOREIGN KEY (project_id) REFERENCES ResearchProject(project_id) ON DELETE RESTRICT
);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX idx_faculty_dept      ON Faculty(department_id);
CREATE INDEX idx_student_dept      ON Student(department_id);
CREATE INDEX idx_project_dept      ON ResearchProject(department_id);
CREATE INDEX idx_project_status    ON ResearchProject(status, end_date);
CREATE INDEX idx_projectrole_proj  ON ProjectRole(project_id);
CREATE INDEX idx_grant_project     ON `Grant`(project_id);
CREATE INDEX idx_grant_status      ON `Grant`(grant_status, project_id);
CREATE INDEX idx_expense_grant     ON Expense(grant_id, expense_date);
CREATE INDEX idx_pub_project       ON Publication(project_id);

-- ============================================================
-- VIEWS
-- ============================================================

-- View 1: Department research summary
CREATE VIEW dept_research_summary AS
SELECT
    d.department_id,
    d.department_name,
    COUNT(DISTINCT p.project_id)                        AS total_projects,
    COUNT(DISTINCT CASE WHEN p.status='Active'
          THEN p.project_id END)                        AS active_projects,
    COALESCE(SUM(CASE WHEN g.grant_status='Awarded'
          THEN g.award_amount END), 0)                  AS total_awarded_funding,
    COUNT(DISTINCT pub.publication_id)                  AS total_publications
FROM Department d
LEFT JOIN ResearchProject p   ON d.department_id = p.department_id
LEFT JOIN `Grant` g           ON p.project_id    = g.project_id
LEFT JOIN Publication pub     ON p.project_id    = pub.project_id
GROUP BY d.department_id, d.department_name;

-- View 2: Active projects with remaining budget
CREATE VIEW active_projects_with_budget AS
SELECT
    p.project_id,
    p.project_title,
    d.department_name,
    COALESCE(SUM(g.award_amount), 0)                    AS total_awarded,
    COALESCE(SUM(e.amount), 0)                          AS total_spent,
    COALESCE(SUM(g.award_amount), 0)
        - COALESCE(SUM(e.amount), 0)                    AS remaining_budget
FROM ResearchProject p
JOIN Department d          ON p.department_id = d.department_id
LEFT JOIN `Grant` g        ON p.project_id    = g.project_id
    AND g.grant_status = 'Awarded'
LEFT JOIN Expense e        ON g.grant_id      = e.grant_id
WHERE p.status = 'Active'
GROUP BY p.project_id, p.project_title, d.department_name;
