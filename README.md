# AI Student Retention Analytics with SQL

## Project Overview

This project demonstrates SQL analytics engineering techniques using a synthetic student retention dataset generated with Python.

The aim of the project is to simulate how universities and educational institutions can use data analytics, SQL, and AI-oriented feature engineering to identify patterns associated with student graduation outcomes and retention risk.

The project explores:
- Student engagement analytics
- Retention-risk analysis
- Behavioral scoring systems
- Window functions
- Warehouse-style aggregations
- AI feature engineering
- KPI reporting
- Analytical filtering
- Classification-style logic

---

# Dataset Overview

I generated a synthetic dataset using Python which contains behavioral, academic, and demographic features associated with student performance and graduation outcomes.

## Dataset Columns

| Column | Description |
|---|---|
| student_id | Unique identifier for each student |
| age | Student age |
| gender | Student gender |
| socio_economic_score | Socioeconomic background score |
| attendance_rate | Attendance percentage |
| average_assignment_score | Average assignment performance |
| midterm_exam_score | Midterm exam score |
| final_exam_score | Final exam score |
| study_hours_per_week | Weekly study hours |
| lms_logins_per_week | Weekly LMS platform activity |
| part_time_job_hours | Weekly part-time work hours |
| financial_aid | Whether the student receives financial aid |
| disciplinary_record | Behavioral risk category |
| graduation_outcome | Graduation outcome classification |

---

# SQL Skills Developed

This project demonstrates:

- CASE statements
- Common Table Expressions (CTEs)
- Window functions
- RANK() and ROW_NUMBER()
- Aggregations and KPI reporting
- Subqueries
- Analytical filtering
- Feature engineering
- Risk scoring systems
- Retention analytics
- Behavioral segmentation
- Warehouse-style reporting

---

# Example Analytical Questions Explored

- Which students are at highest risk of dropping out?
- Does excessive part-time work correlate with poor academic performance?
- Which demographic groups exhibit stronger engagement patterns?
- How can behavioral risk scores be engineered using SQL?
- How can students be ranked within demographic groups using window functions?

---

# Example SQL Query

```sql
SELECT
    student_id,
    gender,

    ROUND(
        (
            0.3 * average_assignment_score
            + 0.3 * midterm_exam_score
            + 0.4 * final_exam_score
        ),
        2
    ) AS weighted_score,

    RANK() OVER (
        PARTITION BY gender
        ORDER BY
            (
                0.3 * average_assignment_score
                + 0.3 * midterm_exam_score
                + 0.4 * final_exam_score
            ) DESC
    ) AS performance_rank

FROM student_data;
```

---

# Technologies Used

| Technology | Purpose |
|---|---|
| Python | Synthetic dataset generation |
| Pandas | Data preprocessing |
| Oracle APEX | My SQL analytics environment |
| SQL | Dataset Extraction, CTEs and feature engineering |

---

# Project Goals

This project is created to strengthen practical skills in:
- SQL analytics engineering
- Dataset/Views preparation for model training
- Behavioral analytics
- Business intelligence reporting
- Data engineering workflows
- Analytical problem solving

---

# Author

By Anthony L. Anumel - Developed as part of a self-directed SQL and analytics engineering learning project.
