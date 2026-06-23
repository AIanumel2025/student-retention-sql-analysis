/* 1. Create a model training dataset to predict graduation outcomes
Build a feature table, which contains:
* Engagement Score
* Academic Score
* Risk Flag
Only include students receiving financial aid
*/

SELECT
    STUDENT_ID,
    0.4 * ATTENDANCE_RATE + 0.3 * STUDY_HOURS_PER_WEEK + 0.3 * LMS_LOGINS_PER_WEEK
        AS ENGAGEMENT_SCORE,
    0.3 * AVERAGE_ASSIGNMENT_SCORE + 0.3 * MIDTERM_EXAM_SCORE + 0.4 * FINAL_EXAM_SCORE
        AS ACADEMIC_SCORE,
    CASE
        WHEN ATTENDANCE_RATE < 70
             OR (
                    0.3 * AVERAGE_ASSIGNMENT_SCORE
                  + 0.3 * MIDTERM_EXAM_SCORE
                  + 0.4 * FINAL_EXAM_SCORE
                ) < 60
        THEN 'HIGH_RISK'
        ELSE 'LOW_RISK'
    END AS RISK_FLAG
FROM STUDENT_DATA
WHERE FINANCIAL_AID = 'TRUE';

/* 2. Create a behavioural segmentation dataset
In the table, calculate an engagement metric, then segment students into behavioural groups for downstream model training
*/

WITH ENGAGEMENT_DATA AS (
    SELECT
        STUDENT_ID,
        GENDER,
        ATTENDANCE_RATE + (LMS_LOGINS_PER_WEEK * 2) + (STUDY_HOURS_PER_WEEK * 3)
            AS ENGAGEMENT_METRIC
    FROM STUDENT_DATA
),
RANKED_DATA AS (
    SELECT
        STUDENT_ID,
        GENDER,
        ENGAGEMENT_METRIC,
        RANK() OVER (
            PARTITION BY GENDER
            ORDER BY ENGAGEMENT_METRIC DESC
        ) AS ENGAGEMENT_RANK,
        NTILE(4) OVER (
            PARTITION BY GENDER
            ORDER BY ENGAGEMENT_METRIC DESC
        ) AS ENGAGEMENT_QUARTILE
    FROM ENGAGEMENT_DATA
)

SELECT
    STUDENT_ID,
    GENDER,
    ENGAGEMENT_METRIC,
    ENGAGEMENT_RANK,

    CASE
        WHEN ENGAGEMENT_QUARTILE = 1
            THEN 'HIGHLY_ENGAGED'

        WHEN ENGAGEMENT_QUARTILE IN (2, 3)
            THEN 'MODERATELY_ENGAGED'

        ELSE 'AT_RISK'
    END AS SEGMENT

FROM RANKED_DATA;

/* 3. Perform a data quality audit to identify records that may negatively impact model performance
I use the following rules to guide me:

Rule 1: Attendance exceeds 100%
Rule 2: Study hours exceed 80 hours
Rule 3: Identifying missing final exam scores
Rule 4: Identifying data inconsistencies
*/

SELECT
    STUDENT_ID,
    'Attendance > 100' AS ISSUE_DETECTED
FROM STUDENT_DATA
WHERE ATTENDANCE_RATE > 100


UNION ALL
SELECT
    STUDENT_ID,
    'Study Hours > 80' AS ISSUE_DETECTED
FROM STUDENT_DATA
WHERE STUDY_HOURS_PER_WEEK > 80


UNION ALL

SELECT
    STUDENT_ID,
    'Missing Final Exam Score' AS ISSUE_DETECTED
FROM STUDENT_DATA
WHERE FINAL_EXAM_SCORE IS NULL

UNION ALL

SELECT
    STUDENT_ID,
    'Potential Data Inconsistency' AS ISSUE_DETECTED
FROM STUDENT_DATA
WHERE ATTENDANCE_RATE < 50
  AND FINAL_EXAM_SCORE > 90;

/* 4. Data Quality audits
Are there any missing values in critical analytical columns?
*/

SELECT
    COUNT(CASE WHEN ATTENDANCE_RATE IS NULL THEN 1 END)
        AS MISSING_ATTENDANCE,
    COUNT(CASE WHEN FINAL_EXAM_SCORE IS NULL THEN 1 END)
        AS MISSING_FINAL_SCORE,
    COUNT(CASE WHEN GRADUATION_OUTCOME IS NULL THEN 1 END)
        AS MISSING_OUTCOME
FROM STUDENT_DATA;

/* 5. Do any duplicate student IDs exist? */

SELECT
    STUDENT_ID,
    COUNT(*) AS DUPLICATE_COUNT
FROM STUDENT_DATA
GROUP BY STUDENT_ID
HAVING COUNT(*) > 1;

/* 6. Create a table view for model training to predict drop out risk outcomes */

SELECT
    STUDENT_ID,
    ATTENDANCE_RATE,
    LMS_LOGINS_PER_WEEK,
    STUDY_HOURS_PER_WEEK,
    FINAL_EXAM_SCORE,
    CASE
        WHEN GRADUATION_OUTCOME = 'DROPOUT_RISK'
        THEN 1
        ELSE 0
    END AS TARGET_LABEL
FROM STUDENT_DATA;

/* 7. The university wants to build a dataset that can be used
to analyse and predict graduate employment outcomes. Construct a model-ready dataset by combining student academic performance data with post-graduation career outcomes.
*/

SELECT
    SD.STUDENT_ID,
    SD.GENDER,
    SD.SOCIO_ECONOMIC_SCORE,
    SD.FINAL_EXAM_SCORE,
    SD.GRADUATION_OUTCOME,
    SC.EMPLOYMENT_STATUS,
    SC.STARTING_SALARY
FROM STUDENT_DATA SD
INNER JOIN STUDENT_CAREER SC
    ON SD.STUDENT_ID = SC.STUDENT_ID;

/* 8. The AI team wants to develop a machine learning model
capable of predicting graduate starting salaries based
on academic performance, demographic information, scholarship outcomes, and employment characteristics. Create a reusable SQL view that assembles a model-ready
dataset for salary prediction.
*/

CREATE VIEW SALARY_PREDICTION AS
SELECT
    SD.AGE,
    SD.GENDER,
    SD.SOCIO_ECONOMIC_SCORE,
    SD.ATTENDANCE_RATE,
    SD.AVERAGE_ASSIGNMENT_SCORE,
    SD.FINAL_EXAM_SCORE,
    SD.STUDY_HOURS_PER_WEEK,
    SS.SCHOLARSHIP_TYPE,
    SS.SCHOLARSHIP_AMOUNT,
    SC.EMPLOYMENT_TYPE,
    SC.REMOTE_WORK_AVAILABILITY,
    SC.CAREER_SATISFACTION_SCORE,
    SC.STARTING_SALARY
FROM STUDENT_DATA SD
INNER JOIN STUDENT_SCHOLARSHIP SS
    ON SD.STUDENT_ID = SS.STUDENT_ID
INNER JOIN STUDENT_CAREER SC
    ON SD.STUDENT_ID = SC.STUDENT_ID;