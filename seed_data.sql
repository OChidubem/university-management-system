-- ============================================================
--  University Research Management System - Sample Data
--  CSCI 411 | Chidubem Okoye & Praptika Bajracharya
-- ============================================================
USE urms;

-- Departments
INSERT INTO Department (department_name, college_name, office_location) VALUES
('Computer Science',          'College of Engineering',          'ENG 201'),
('Biology',                   'College of Natural Sciences',     'SCI 110'),
('Chemistry',                 'College of Natural Sciences',     'SCI 220'),
('Electrical Engineering',    'College of Engineering',          'ENG 315'),
('Mathematics',               'College of Arts & Sciences',      'LIB 405');

-- Faculty
INSERT INTO Faculty (first_name, last_name, email, `rank`, department_id) VALUES
('Aiden',    'Zhao',     'azhao@university.edu',    'Professor',             1),
('Maria',    'Reyes',    'mreyes@university.edu',   'Associate Professor',   1),
('Samuel',   'Okafor',   'sokafor@university.edu',  'Assistant Professor',   2),
('Priya',    'Nair',     'pnair@university.edu',    'Professor',             3),
('James',    'Chen',     'jchen@university.edu',    'Associate Professor',   4),
('Layla',    'Adkins',   'ladkins@university.edu',  'Assistant Professor',   5);

-- Students
INSERT INTO Student (first_name, last_name, email, major, graduation_year, department_id) VALUES
('Carlos',  'Mendez',   'cmendez@student.edu',   'Computer Science',     2025, 1),
('Amara',   'Diallo',   'adiallo@student.edu',   'Biology',              2026, 2),
('Kevin',   'Park',     'kpark@student.edu',     'Computer Science',     2024, 1),
('Sophie',  'Larson',   'slarson@student.edu',   'Chemistry',            2025, 3),
('Elijah',  'Torres',   'etorres@student.edu',   'Electrical Eng.',      2025, 4),
('Nina',    'Ivanova',  'nivanova@student.edu',  'Mathematics',          2026, 5),
('Hassan',  'Al-Amin',  'halamin@student.edu',   'Computer Science',     2025, 1);

-- Research Projects
INSERT INTO ResearchProject (project_title, abstract, start_date, end_date, status, department_id) VALUES
('ML-Based Intrusion Detection System',
 'Developing a machine learning pipeline to identify network intrusions in real time.',
 '2023-08-15', NULL, 'Active', 1),

('CRISPR Gene Editing in Plant Immunity',
 'Using CRISPR-Cas9 to enhance disease resistance in common crop plants.',
 '2023-01-10', '2025-06-30', 'Active', 2),

('Quantum-Dot Solar Cells',
 'Investigating efficiency improvements in solar cells via quantum-dot layer deposition.',
 '2022-09-01', '2024-12-31', 'Completed', 3),

('Federated Learning for Healthcare Privacy',
 'Privacy-preserving federated learning applied to hospital EHR datasets.',
 '2024-01-20', NULL, 'Active', 1),

('Graph Neural Networks for Drug Discovery',
 'Applying GNNs to predict molecular binding affinities for new drug candidates.',
 '2023-05-01', NULL, 'Active', 1),

('Autonomous Drone Navigation',
 'Reinforcement learning methods for obstacle avoidance in GPS-denied environments.',
 '2022-03-01', '2023-12-31', 'Completed', 4),

('Statistical Models for Climate Data',
 'Bayesian hierarchical models applied to long-term climate measurement datasets.',
 '2024-03-01', NULL, 'Proposed', 5);

-- Project Roles
INSERT INTO ProjectRole (project_id, person_type, person_id, role_name, date_joined) VALUES
(1, 'Faculty',  1, 'PI',                  '2023-08-15'),
(1, 'Faculty',  2, 'Co-PI',               '2023-08-15'),
(1, 'Student',  1, 'Research Assistant',  '2023-09-01'),
(1, 'Student',  3, 'Data Analyst',        '2023-09-15'),
(2, 'Faculty',  3, 'PI',                  '2023-01-10'),
(2, 'Student',  2, 'Research Assistant',  '2023-02-01'),
(3, 'Faculty',  4, 'PI',                  '2022-09-01'),
(3, 'Student',  4, 'Lab Assistant',       '2022-09-15'),
(4, 'Faculty',  2, 'PI',                  '2024-01-20'),
(4, 'Student',  7, 'Research Assistant',  '2024-02-01'),
(5, 'Faculty',  1, 'PI',                  '2023-05-01'),
(5, 'Student',  1, 'Data Analyst',        '2023-05-10'),
(5, 'Student',  3, 'Research Assistant',  '2023-06-01'),
(6, 'Faculty',  5, 'PI',                  '2022-03-01'),
(6, 'Student',  5, 'Research Assistant',  '2022-03-15'),
(7, 'Faculty',  6, 'PI',                  '2024-03-01'),
(7, 'Student',  6, 'Research Assistant',  '2024-03-15');

-- Sponsors
INSERT INTO Sponsor (sponsor_name, sponsor_type, contact_email) VALUES
('National Science Foundation',   'Government',  'grants@nsf.gov'),
('NIH - National Institutes of Health', 'Government', 'grants@nih.gov'),
('Google Research',               'Industry',    'research@google.com'),
('Bill & Melinda Gates Foundation','Nonprofit',   'research@gatesfoundation.org'),
('University Internal Fund',      'Internal',    'research@university.edu');

-- Grants
INSERT INTO ProjectGrant (sponsor_id, project_id, grant_title, award_amount, award_date, grant_status) VALUES
(1, 1, 'NSF Cybersecurity Initiative 2023',        450000.00, '2023-07-01', 'Awarded'),
(2, 2, 'NIH Plant Immunity CRISPR Grant',          320000.00, '2022-12-15', 'Awarded'),
(3, 1, 'Google AI Security Research Award',        200000.00, '2023-10-01', 'Awarded'),
(1, 4, 'NSF Privacy-Preserving ML Grant',          500000.00, '2024-01-01', 'Awarded'),
(4, 5, 'Gates Foundation Drug Discovery Grant',    750000.00, '2023-04-01', 'Awarded'),
(5, 7, 'Internal Climate Modeling Seed Grant',      25000.00, '2024-02-15', 'Awarded'),
(1, 3, 'NSF Solar Energy Research (Closed)',       275000.00, '2022-08-01', 'Closed'),
(3, 4, 'Google Cloud Healthcare ML Support',       150000.00, '2024-03-01', 'Awarded');

-- Expenses
INSERT INTO Expense (grant_id, expense_date, category, amount, description) VALUES
(1, '2023-09-01', 'Equipment',  32000.00, 'GPU cluster for ML training'),
(1, '2023-10-15', 'Personnel',  85000.00, 'RA stipends Q1'),
(1, '2024-01-10', 'Travel',      4200.00, 'IEEE S&P conference travel'),
(2, '2023-03-01', 'Equipment',  18000.00, 'CRISPR lab supplies'),
(2, '2023-06-15', 'Personnel',  60000.00, 'Lab technician salary'),
(3, '2023-11-01', 'Equipment',  25000.00, 'High-performance workstations'),
(4, '2024-02-01', 'Personnel',  90000.00, 'Research assistant salaries'),
(4, '2024-04-01', 'Supplies',    5500.00, 'Cloud compute credits'),
(5, '2023-06-01', 'Equipment',  45000.00, 'Molecular simulation server'),
(5, '2023-09-01', 'Travel',      8500.00, 'NeurIPS conference travel'),
(6, '2024-04-01', 'Supplies',    3200.00, 'Dataset licensing'),
(7, '2022-10-01', 'Equipment',  60000.00, 'Drone hardware and sensors'),
(7, '2022-12-01', 'Personnel',  50000.00, 'Engineer salary');

-- Publications
INSERT INTO Publication (project_id, title, publication_type, venue_name, publication_date, doi_or_url) VALUES
(1, 'Real-Time Network Intrusion Detection via Gradient Boosted Trees',
    'Conference', 'IEEE Symposium on Security and Privacy', '2024-05-20',
    'https://doi.org/10.1109/sp.2024.00123'),
(1, 'Benchmark Study of ML Classifiers for Network Anomaly Detection',
    'Journal', 'IEEE Transactions on Information Forensics', '2024-08-01',
    'https://doi.org/10.1109/tifs.2024.00456'),
(2, 'CRISPR-Mediated Enhancement of Pathogen Resistance in Arabidopsis',
    'Journal', 'Nature Plants', '2024-03-12',
    'https://doi.org/10.1038/s41477-024-00789'),
(3, 'Efficiency Limits in Quantum-Dot Photovoltaics: A Review',
    'Journal', 'Advanced Energy Materials', '2023-11-05',
    'https://doi.org/10.1002/aenm.202300987'),
(3, 'Deposition Techniques for Quantum-Dot Solar Layers',
    'Conference', 'IEEE Photovoltaic Specialists Conference', '2023-06-15',
    'https://doi.org/10.1109/pvsc.2023.00321'),
(5, 'Graph Neural Networks for Protein-Ligand Binding Prediction',
    'Conference', 'NeurIPS 2023 Workshop on ML4Molecules', '2023-12-10',
    'https://doi.org/10.48550/arxiv.2312.00654'),
(6, 'Sim-to-Real Transfer for Autonomous UAV Navigation',
    'Conference', 'IEEE ICRA 2023', '2023-05-29',
    'https://doi.org/10.1109/icra48891.2023.10161234');
