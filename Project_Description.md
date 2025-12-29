# --SQL-Hackathon-End-to-End-Healthcare-Management
Healthcare Management Database System
📌 Overview
This project demonstrates the design and implementation of a normalized healthcare database using SQL. It transforms raw patient and doctor data into structured relational tables, enforces constraints, and enables advanced analytical queries for hospital management.
The goal is to show how hospitals can manage patients, doctors, departments, and locations efficiently, while also generating insights such as department activity levels and doctor performance.

⚙️ Features
- Normalized schema: Splits raw source data into clean relational tables (patients, doctors, departments, locations).
- Sequences & IDs: Auto-generates unique identifiers (DEP-001, DOC-001, PAT-001, LOC-001).
- Constraints: Gender validation, foreign keys, uniqueness checks.
- Joins & Relationships: Patients linked to doctors, doctors linked to departments, patients linked to locations.
- Analytical Queries:
- Rank departments by patient visits.
- Identify doctors treating more patients than the department average.

🗂️ Schema Design
Tables created:
- HEALTHCARE_SOURCE_TB → Raw source data.
- DEP_TB → Department master table.
- DOC_TB → Doctor master table linked to departments.
- LOCATION_TB → Patient address/location details.
- PATIENT_TB → Final patient table linked to doctor and location.
Entity-Relationship Diagram (Vertical Layout):

 Patient (M)
    |
    v
Doctor (1) (M)
    |
    v
Department (1)

Patient (M)
    |
    v
Location (1)

Healthcare_Source (staging)

🚀 How to Run
- Clone the repo.
- Run the SQL scripts in order:
- Create source table (HEALTHCARE_SOURCE_TB).
- Create sequences and normalized tables (DEP_TB, DOC_TB, LOCATION_TB, PATIENT_TB).
- Insert data from source into normalized tables.
- Execute analytical queries to generate insights.

📈 Insights Generated
- Departments ranked by patient activity.
- Doctors compared against department averages.
- Clean relational structure for future hospital analytics (appointments, billing, reporting).

🔮 Future Scope
- Add appointments and billing tables.
- Build dashboards using Power BI/Tableau.



