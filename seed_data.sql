-- ============================================================
-- seed_data.sql — Test data for URMS
-- ============================================================
USE urms;

-- Departments
INSERT INTO Department (department_name, college_name, office_location) VALUES
('Computer Science',  'College of Science & Engineering', 'Brown Hall 301'),
('Biology',           'College of Science & Engineering', 'Wick Science 210'),
('Psychology',        'College of Social Sciences',       'Centennial Hall 110'),
('Engineering',       'College of Science & Engineering', 'Brown Hall 101');

-- Faculty
INSERT INTO Faculty (first_name, last_name, email, rank, department_id) VALUES
('James',   'Morton',   'j.morton@urms.edu',   'Professor',  1),
('Linda',   'Tran',     'l.tran@urms.edu',     'Associate',  1),
('Marcus',  'Webb',     'm.webb@urms.edu',     'Assistant',  2),
('Sophia',  'Chen',     's.chen@urms.edu',     'Professor',  2),
('Amir',    'Patel',    'a.patel@urms.edu',    'Associate',  3),
('Rachel',  'Kim',      'r.kim@urms.edu',      'Assistant',  4);

-- Students
INSERT INTO Student (first_name, last_name, email, major, graduation_year, department_id) VALUES
('Chidubem', 'Okoye',       'c.okoye@urms.edu',      'Computer Science', 2025, 1),
('Praptika', 'Bajracharya', 'p.bajracharya@urms.edu', 'Computer Science', 2025, 1),
('Tyler',    'Brooks',      't.brooks@urms.edu',      'Biology',          2026, 2),
('Amara',    'Diallo',      'a.diallo@urms.edu',      'Psychology',       2025, 3),
('Jin',      'Park',        'j.park@urms.edu',        'Engineering',      2026, 4);

-- Research Projects
INSERT INTO ResearchProject (project_title, abstract, start_date, end_date, status, department_id) VALUES
('AI-Driven Anomaly Detection in Network Traffic',
 'Applies ML to detect intrusion patterns in real-time network flows.',
 '2024-01-15', NULL, 'Active', 1),
('Genomic Markers in Stress Response',
 'Identifies gene expression changes under cortisol-induced stress.',
 '2023-09-01', '2025-05-31', 'Active', 2),
('Cognitive Load in Remote Learning Environments',
 'Measures cognitive overload in students attending fully remote classes.',
 '2024-03-01', NULL, 'Active', 3),
('Sustainable Composite Materials for Aerospace',
 'Develops bio-based composite materials as alternatives to carbon fiber.',
 '2022-06-01', '2024-12-31', 'Completed', 4),
('Federated Learning for Healthcare Privacy',
 'Trains ML models across hospital nodes without sharing raw patient data.',
 '2023-11-01', NULL, 'Active', 1);

-- ProjectRoles
INSERT INTO ProjectRole (project_id, person_type, person_id, role_name, date_joined) VALUES
(1, 'Faculty',  1, 'PI',                 '2024-01-15'),
(1, 'Faculty',  2, 'Co-PI',              '2024-01-15'),
(1, 'Student',  1, 'Research Assistant', '2024-02-01'),
(1, 'Student',  2, 'Data Analyst',       '2024-02-01'),
(2, 'Faculty',  3, 'PI',                 '2023-09-01'),
(2, 'Faculty',  4, 'Co-PI',              '2023-09-01'),
(2, 'Student',  3, 'Research Assistant', '2023-10-01'),
(3, 'Faculty',  5, 'PI',                 '2024-03-01'),
(3, 'Student',  4, 'Research Assistant', '2024-03-15'),
(4, 'Faculty',  6, 'PI',                 '2022-06-01'),
(5, 'Faculty',  1, 'PI',                 '2023-11-01'),
(5, 'Faculty',  2, 'Co-PI',              '2023-11-01'),
(5, 'Student',  1, 'Research Assistant', '2024-01-10');

-- Sponsors
INSERT INTO Sponsor (sponsor_name, sponsor_type, contact_email) VALUES
('National Science Foundation',    'Government', 'grants@nsf.gov'),
('National Institutes of Health',  'Government', 'grants@nih.gov'),
('Department of Energy',           'Government', 'grants@doe.gov'),
('TechCorp Research Division',     'Industry',   'research@techcorp.com'),
('University Internal Fund',       'Internal',   'research@urms.edu');

-- Grants
INSERT INTO `Grant` (sponsor_id, project_id, grant_title, award_amount, award_date, grant_status) VALUES
(1, 1, 'NSF: AI Network Security Initiative',       250000.00, '2024-01-01', 'Awarded'),
(2, 2, 'NIH: Genomic Stress Response Study',        180000.00, '2023-08-15', 'Awarded'),
(3, 4, 'DOE: Sustainable Aerospace Materials',      220000.00, '2022-05-01', 'Closed'),
(4, 1, 'TechCorp: Real-Time Intrusion Detection',    75000.00, '2024-03-01', 'Awarded'),
(5, 3, 'Internal: Remote Learning Cognitive Study',  45000.00, '2024-02-15', 'Awarded'),
(1, 5, 'NSF: Federated Healthcare ML',              310000.00, '2023-10-01', 'Awarded'),
(2, 5, 'NIH: Privacy-Preserving Medical AI',        175000.00, NULL,         'Submitted');

-- Expenses
INSERT INTO Expense (grant_id, expense_date, category, amount, description) VALUES
(1, '2024-02-10', 'Equipment',  18500.00, 'GPU cluster expansion'),
(1, '2024-03-05', 'Personnel',  32000.00, 'RA salaries Q1'),
(1, '2024-04-12', 'Supplies',    2800.00, 'Network hardware'),
(2, '2023-10-01', 'Personnel',  45000.00, 'Lab technician salary'),
(2, '2024-01-15', 'Equipment',  22500.00, 'Gene sequencer maintenance'),
(2, '2024-02-20', 'Travel',      4200.00, 'Conference — Boston'),
(4, '2024-03-15', 'Personnel',  28000.00, 'Contract developer'),
(4, '2024-04-01', 'Travel',      3500.00, 'Industry partner visit'),
(5, '2024-03-01', 'Equipment',   8900.00, 'Survey platform license'),
(5, '2024-04-10', 'Supplies',    1200.00, 'Participant incentives'),
(6, '2023-12-01', 'Equipment',  42000.00, 'Secure server nodes'),
(6, '2024-01-20', 'Personnel',  68000.00, 'Research engineer salary'),
(6, '2024-03-10', 'Travel',      5800.00, 'ICML conference'),
(3, '2023-06-01', 'Equipment',  85000.00, 'Composite testing rig'),
(3, '2024-01-10', 'Supplies',   12000.00, 'Raw bio-composite materials');

-- Publications
INSERT INTO Publication (project_id, title, publication_type, venue_name, publication_date, doi_or_url) VALUES
(1, 'Real-Time Anomaly Detection Using Transformer-Based Models',
    'Conference', 'IEEE Symposium on Security & Privacy', '2024-05-20', '10.1109/SP.2024.00041'),
(2, 'Cortisol-Induced Gene Expression Patterns in Human Fibroblasts',
    'Journal', 'Nature Genetics', '2024-03-15', '10.1038/ng.2024.0087'),
(4, 'Bio-Composite Tensile Strength Comparison for Aerospace Applications',
    'Journal', 'Composites Science and Technology', '2024-09-01', '10.1016/j.compscitech.2024.110123'),
(4, 'Lifecycle Analysis of Sustainable Aerospace Materials',
    'Conference', 'AIAA SciTech Forum', '2024-01-08', '10.2514/6.2024-1892'),
(5, 'Federated Learning Under Non-IID Distributions in Hospital Networks',
    'Conference', 'NeurIPS 2024', '2024-12-10', '10.48550/arXiv.2024.09871');
