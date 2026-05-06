# University Research Management System

A relational database project for managing university research activity, including departments, faculty, students, research projects, project roles, sponsors, grants, expenses, publications, reporting views, indexing, transactions, and a NoSQL publication metadata component.

This project was developed for **CSCI 411/511** as a complete database design and implementation project.

---

## Project Overview

Universities often manage research information across spreadsheets, emails, grant documents, department records, and publication lists. This can make it difficult to track who is involved in each project, how much funding has been awarded, how much of a grant has been spent, which departments are most active, and which projects have produced publications.

The **University Research Management System (URMS)** solves this problem by organizing research-related data into a structured database system. The project supports both operational data management and analytical reporting.

---

## Team Members

- **Chidubem Okoye**
- **Praptika Bajracharya**

---

## Main Features

- Relational schema for university research management
- Normalized table design using 1NF, 2NF, and 3NF principles
- Primary key, foreign key, unique, not-null, enum, and check constraints
- Sample dataset for testing realistic research activity
- Analytical SQL queries using joins, aggregation, grouping, subqueries, and correlated subqueries
- Reusable SQL views for department summaries and active project budget tracking
- Indexes for query optimization
- Transaction logic for safe multi-step database operations
- Python application demo with SELECT, INSERT, UPDATE, DELETE, prepared statements, and transaction handling
- MongoDB NoSQL component for flexible publication metadata

---

## Technology Stack

| Area | Technology |
|---|---|
| Database | MySQL |
| Database GUI | MySQL Workbench |
| Application Demo | Python |
| Python Driver | mysql-connector-python |
| NoSQL Component | MongoDB |
| NoSQL GUI | MongoDB Compass |
| Version Control | Git and GitHub |

---

## Database Name

The MySQL database used in this project is:

```sql
urms
university-management-system/
│
├── README.md
├── schema.sql
├── seed_data.sql
├── queries.sql
├── app_demo.py
└── docs/
    └── ER diagram / presentation files if included
