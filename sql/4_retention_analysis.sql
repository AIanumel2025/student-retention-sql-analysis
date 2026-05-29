1. Which students are working more than average but performing below average academically?
In this query, I identify students whose work commitments may be negatively impacting academic
performance.
Criteria used:
- Above-average part-time job hours
- Below-average final exam score

WITH METRICS AS (
    SELECT
        AVG(PART_TIME_JOB_HOURS)
            AS AVG_WORK_HOURS,

        AVG(FINAL_EXAM_SCORE)
            AS AVG_FINAL_SCORE

    FROM STUDENT_DATA
)
SELECT
    STUDENT_ID,
    PART_TIME_JOB_HOURS,
    FINAL_EXAM_SCORE,
    GRADUATION_OUTCOME

FROM STUDENT_DATA,
     METRICS

WHERE PART_TIME_JOB_HOURS > AVG_WORK_HOURS
  AND FINAL_EXAM_SCORE < AVG_FINAL_SCORE

ORDER BY PART_TIME_JOB_HOURS DESC;

2. Which students are underperforming compared with overall engagement benchmarks? I identify students whose attendance, LMS activity and exam performance are all below institutional averages.

WITH BENCHMARKS AS (
    SELECT
        AVG(ATTENDANCE_RATE) AS AVG_ATTENDANCE,
        AVG(LMS_LOGINS_PER_WEEK) AS AVG_LMS,
        AVG(FINAL_EXAM_SCORE) AS AVG_FINAL
    FROM STUDENT_DATA
)
SELECT
    S.STUDENT_ID,
    S.ATTENDANCE_RATE,
    S.LMS_LOGINS_PER_WEEK,
    S.FINAL_EXAM_SCORE,
    S.GRADUATION_OUTCOME

FROM STUDENT_DATA S
CROSS JOIN BENCHMARKS B

WHERE S.ATTENDANCE_RATE < B.AVG_ATTENDANCE
AND S.LMS_LOGINS_PER_WEEK < B.AVG_LMS
AND S.FINAL_EXAM_SCORE < B.AVG_FINAL;

3. Which graduation outcomes exhibit the weakest engagement patterns? Comparing engagement metrics across graduation outcomes.

SELECT
    GRADUATION_OUTCOME,
    COUNT(*) AS TOTAL_STUDENTS,
    ROUND(AVG(ATTENDANCE_RATE), 2)
        AS AVG_ATTENDANCE,
    ROUND(AVG(LMS_LOGINS_PER_WEEK), 2)
        AS AVG_LMS_ACTIVITY,
    ROUND(AVG(STUDY_HOURS_PER_WEEK), 2)
        AS AVG_STUDY_HOURS,
    ROUND(AVG(FINAL_EXAM_SCORE), 2)
        AS AVG_FINAL_SCORE
FROM STUDENT_DATA
GROUP BY GRADUATION_OUTCOME
ORDER BY AVG_FINAL_SCORE ASC;

4. How many students meet common retention-risk criteria? 
I measure the size of the student population considered at risk, using the criteria below:
* Attendance below 65 or
* Critical disciplinary record or
* Final exam score below 50

SELECT
    COUNT(
        CASE
            WHEN ATTENDANCE_RATE < 65
              OR DISCIPLINARY_RECORD = 'CRITICAL'
              OR FINAL_EXAM_SCORE < 50
            THEN 1
        END
    ) AS AT_RISK_STUDENTS,
    COUNT(*) AS TOTAL_STUDENTS,
    ROUND(
        COUNT(
            CASE
                WHEN ATTENDANCE_RATE < 65
                  OR DISCIPLINARY_RECORD = 'CRITICAL'
                  OR FINAL_EXAM_SCORE < 50
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS AT_RISK_PERCENTAGE
FROM STUDENT_DATA;

5. Which students are highly engaged but still underperform academically? 

SELECT
    STUDENT_ID,
    ATTENDANCE_RATE,
    LMS_LOGINS_PER_WEEK,
    STUDY_HOURS_PER_WEEK,
    FINAL_EXAM_SCORE,
    GRADUATION_OUTCOME

FROM STUDENT_DATA

WHERE ATTENDANCE_RATE >= 80
AND LMS_LOGINS_PER_WEEK >= 10
AND STUDY_HOURS_PER_WEEK >= 15
AND FINAL_EXAM_SCORE < 50;
