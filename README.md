# AI Student Retention Analytics with SQL

## Project Overview

This project demonstrates SQL analytics engineering techniques using a synthetic student retention dataset generated with Python.

My aim of this project is to simulate how universities, educational institutions and school districts could use SQL, analytics engineering and AI-oriented feature engineering to identify patterns associated with student graduation outcomes, retention risk, scholarship eligibility, and post-graduation career success. It evolves from single table SQL practice to multi-table relational analysis, which is commonly found in real world AI and data engineering workflows.

The project explores:

* Student engagement analytics
* Retention-risk analysis
* Behavioural scoring systems
* Window functions
* Warehouse-style aggregations
* AI feature engineering
* KPI reporting
* Analytical filtering
* Classification-style logic
* Relational data modeling
* Multi-table joins
* Dataset enrichment
* Feature-store style dataset construction

---

# Project Datasets

I made three related datasets connected through a common key as follows:

```text
                 STUDENT_DATA
                      |
                 student_id
                 /         \
                /           \
               /             \
              ▼               ▼

     STUDENT_CAREER    STUDENT_SCHOLARSHIP
```

Creating these datasets allows me to simulate a simplified educational data warehouse suitable for SQL analytics, feature engineering, and AI model preparation.

---

## 1. STUDENT_DATA

The primary dataset containing demographic, academic, behavioural, and engagement information.

### Dataset Columns

| Column                   | Description                        |
| ------------------------ | ---------------------------------- |
| student_id               | Unique identifier for each student |
| age                      | Student age                        |
| gender                   | Student gender                     |
| socio_economic_score     | Socioeconomic category             |
| attendance_rate          | Attendance percentage              |
| average_assignment_score | Average assignment performance     |
| midterm_exam_score       | Midterm exam score                 |
| final_exam_score         | Final exam score                   |
| study_hours_per_week     | Weekly study hours                 |
| lms_logins_per_week      | Weekly LMS platform activity       |
| part_time_job_hours      | Weekly part-time work hours        |
| financial_aid            | Financial aid status               |
| disciplinary_record      | Behavioural risk indicator          |
| graduation_outcome       | Graduation outcome classification  |

---

## 2. STUDENT_SCHOLARSHIP

Simulates scholarship eligibility and scholarship award decisions after graduation.

### Example Features

| Column                | Description                    |
| --------------------- | ------------------------------ |
| scholarship_id        | Scholarship record identifier  |
| student_id            | Student identifier             |
| scholarship_eligible  | Scholarship eligibility status |
| scholarship_type      | Scholarship category           |
| scholarship_score     | Scholarship evaluation score   |
| award_amount          | Scholarship award value        |
| recommendation_status | Scholarship review outcome     |
| qualification_date    | Qualification date             |
| post_graduate_program | Intended postgraduate program  |

---

## 3. STUDENT_CAREER

Simulates post-graduation employment outcomes.

### Example Features

| Column                    | Description                     |
| ------------------------- | ------------------------------- |
| career_record_id          | Career record identifier        |
| student_id                | Student identifier              |
| employment_status         | Employment outcome              |
| industry                  | Industry sector                 |
| job_title                 | Graduate job title              |
| months_to_first_job       | Time taken to secure employment |
| starting_salary           | Starting salary                 |
| company_size              | Employer size category          |
| remote_work               | Remote work status              |
| career_satisfaction_score | Career satisfaction score       |

---

# Repository Structure

```
student-retention-sql-analysis/
│
├── datasets/
│   ├── student_data.csv
│   ├── student_scholarship.csv
│   └── student_career.csv
│
├── notebooks/
│   ├── creating_datasets.ipynb
│   └── generated_student_data.ipynb
│
├── sql/
│   ├── 1_basic_analytics.sql
│   ├── 2_feature_engineering.sql
│   ├── 3_window_functions.sql
│   ├── 4_business_analysis.sql
│   ├── 5_model_preparation.sql
│   └── 6_joins_and_feature_enrichment.sql
│
├── images/
│   ├── graduation prediction View.png
│   ├── oracle_apex_dataset.png
│   ├── quantify student engagement into meaningful categories.png
│   └── top performing students within each gender group.png
│
└── README.md
```
---

# SQL Skills Developed

This project demonstrates:

* CASE statements
* Common Table Expressions (CTEs)
* Window functions
* RANK()
* ROW_NUMBER()
* Aggregations and KPI reporting
* Subqueries
* Analytical filtering
* Feature engineering
* Risk scoring systems
* Retention analytics
* Behavioural segmentation
* Multi-table joins
* INNER JOIN
* LEFT JOIN
* Dataset enrichment
* Relational data modeling
* Warehouse-style reporting
* AI training dataset preparation

---

# Some Analytical Questions Explored

## Student Retention and Academic Performance

* Which students are at highest risk of dropping out?
* Does excessive part-time work correlate with poor academic performance?
* Which demographic groups exhibit stronger engagement patterns?
* How can behavioural risk scores be engineered using SQL?

## Scholarship Analytics

* Which students qualify for scholarships?
* Which socioeconomic groups receive scholarships most frequently?
* How does scholarship eligibility relate to academic performance?

## Career Outcome Analytics

* Do scholarship recipients achieve stronger employment outcomes?
* Which student characteristics correlate with higher starting salaries?
* Which graduates outperform their scholarship cohort in salary outcomes?

## AI-Oriented Feature Engineering

* How can students be compared against peer-group averages?
* How can benchmark-based performance features be engineered?
* How can multi-table datasets be assembled for model training?

---

# An example of one SQL Query

```sql
WITH scholarship_stats AS (
    SELECT
        SS.student_id,
        SS.scholarship_type,
        SC.starting_salary,
        AVG(SC.starting_salary)
            OVER (
                PARTITION BY SS.scholarship_type
            ) AS scholarship_type_avg_salary
    FROM student_scholarship SS
    INNER JOIN student_career SC
        ON SS.student_id = SC.student_id
)

SELECT
    student_id,
    scholarship_type,
    starting_salary,
    scholarship_type_avg_salary,
    starting_salary - scholarship_type_avg_salary AS difference
FROM scholarship_stats
WHERE starting_salary >= scholarship_type_avg_salary + 10000
ORDER BY difference DESC;
```

---

# Technologies Used

| Technology       | Purpose                                                     |
| ---------------- | ----------------------------------------------------------- |
| Python           | Synthetic dataset generation                                |
| Pandas           | Data preprocessing                                          |
| Jupyter Notebook | For Dataset generation and experimentation                      |
| Oracle APEX      | SQL analytics environment                                   |
| SQL              | Analytics, joins, feature engineering and model preparation |

---

# Project Goals

This project is designed to strengthen practical skills in:

* SQL analytics engineering
* Relational data modeling
* Feature engineering for AI systems
* Dataset preparation for machine learning
* Business intelligence reporting
* Data engineering workflows
* SQL joins and data enrichment
* Analytical problem solving
* Training dataset construction

---

# Author

**Anthony L. Anumel**

Developed as part of a self-directed SQL, Data and AI Engineering learning journey.
