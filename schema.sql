-- ============================================================
--  University Research Management System
--  CSCI 411 | Chidubem Okoye & Praptika Bajracharya
--  DDL - MySQL
-- ============================================================

CREATE DATABASE IF NOT EXISTS urms;
USE urms;

-- 1. Department
CREATE TABLE Department (
    department_id   INT           AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100)  NOT NULL,
    college_name    VARCHAR(100)  NOT NULL,
    office_location VARCHAR(100)
);

-- 2. Faculty
CREATE TABLE Faculty (
    faculty_id      INT           AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)   NOT NULL,
    last_name       VARCHAR(50)   NOT NULL,
    email           VARCHAR(100)  NOT NULL UNIQUE,
    `rank`          ENUM('Assistant Professor','Associate Professor','Professor') NOT NULL,
    department_id   INT           NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 3. Student
CREATE TABLE Student (
    student_id       INT           AUTO_INCREMENT PRIMARY KEY,
    first_name       VARCHAR(50)   NOT NULL,
    last_name        VARCHAR(50)   NOT NULL,
    email            VARCHAR(100)  NOT NULL UNIQUE,
    major            VARCHAR(100),
    graduation_year  YEAR,
    department_id    INT           NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 4. ResearchProject
CREATE TABLE ResearchProject (
    project_id    INT           AUTO_INCREMENT PRIMARY KEY,
    project_title VARCHAR(200)  NOT NULL,
    abstract      TEXT,
    start_date    DATE          NOT NULL,
    end_date      DATE,
    status        ENUM('Proposed','Active','Completed','Suspended') NOT NULL DEFAULT 'Proposed',
    department_id INT           NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (end_date IS NULL OR end_date > start_date)
);

-- 5. ProjectRole  (resolves M:N between Faculty/Student and ResearchProject)
CREATE TABLE ProjectRole (
    role_id      INT           AUTO_INCREMENT PRIMARY KEY,
    project_id   INT           NOT NULL,
    person_type  ENUM('Faculty','Student') NOT NULL,
    person_id    INT           NOT NULL,
    role_name    VARCHAR(100)  NOT NULL,
    date_joined  DATE          NOT NULL,
    FOREIGN KEY (project_id) REFERENCES ResearchProject(project_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. Sponsor
CREATE TABLE Sponsor (
    sponsor_id    INT           AUTO_INCREMENT PRIMARY KEY,
    sponsor_name  VARCHAR(150)  NOT NULL,
    sponsor_type  ENUM('Government','Industry','Nonprofit','Internal') NOT NULL,
    contact_email VARCHAR(100)
);

-- 7. Grant
CREATE TABLE ProjectGrant (
    grant_id      INT             AUTO_INCREMENT PRIMARY KEY,
    sponsor_id    INT             NOT NULL,
    project_id    INT             NOT NULL,
    grant_title   VARCHAR(200)    NOT NULL,
    award_amount  DECIMAL(15,2)   NOT NULL,
    award_date    DATE            NOT NULL,
    grant_status  ENUM('Submitted','Awarded','Rejected','Closed') NOT NULL DEFAULT 'Submitted',
    FOREIGN KEY (sponsor_id)  REFERENCES Sponsor(sponsor_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (project_id)  REFERENCES ResearchProject(project_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (award_amount >= 0)
);

-- 8. Expense
CREATE TABLE Expense (
    expense_id   INT             AUTO_INCREMENT PRIMARY KEY,
    grant_id     INT             NOT NULL,
    expense_date DATE            NOT NULL,
    category     ENUM('Equipment','Travel','Personnel','Supplies','Other') NOT NULL,
    amount       DECIMAL(12,2)   NOT NULL,
    description  VARCHAR(255),
    FOREIGN KEY (grant_id) REFERENCES ProjectGrant(grant_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (amount > 0)
);

-- 9. Publication
CREATE TABLE Publication (
    publication_id   INT           AUTO_INCREMENT PRIMARY KEY,
    project_id       INT           NOT NULL,
    title            VARCHAR(300)  NOT NULL,
    publication_type ENUM('Journal','Conference','Poster','Thesis') NOT NULL,
    venue_name       VARCHAR(200),
    publication_date DATE,
    doi_or_url       VARCHAR(300),
    FOREIGN KEY (project_id) REFERENCES ResearchProject(project_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
--  INDEXES  (frequently joined / filtered columns)
-- ============================================================
CREATE INDEX idx_faculty_dept      ON Faculty(department_id);
CREATE INDEX idx_student_dept      ON Student(department_id);
CREATE INDEX idx_project_dept      ON ResearchProject(department_id);
CREATE INDEX idx_project_status    ON ResearchProject(status);
CREATE INDEX idx_role_project       ON ProjectRole(project_id);
CREATE INDEX idx_grant_project      ON ProjectGrant(project_id);
CREATE INDEX idx_grant_sponsor      ON ProjectGrant(sponsor_id);
CREATE INDEX idx_grant_status       ON ProjectGrant(grant_status);
CREATE INDEX idx_expense_grant      ON Expense(grant_id);
CREATE INDEX idx_pub_project        ON Publication(project_id);
