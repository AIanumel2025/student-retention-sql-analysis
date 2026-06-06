1. Create a binary risk label AT_RISK, that identifies students likely to struggle academically

SELECT
    STUDENT_ID,
    GRADUATION_OUTCOME,

    CASE
        WHEN ATTENDANCE_RATE < 65
          OR DISCIPLINARY_RECORD = 'CRITICAL'
          OR FINAL_EXAM_SCORE < 50
        THEN 'YES'
        ELSE 'NO'
    END AS AT_RISK

FROM STUDENT_DATA;

2. Create a weighted academic score with the following:
30% Assignment Score
30% Midterm Score
40% Final Exam Score

SELECT
    STUDENT_ID,
    GRADUATION_OUTCOME,

    ROUND(
        (
            0.3 * AVERAGE_ASSIGNMENT_SCORE
            + 0.3 * MIDTERM_EXAM_SCORE
            + 0.4 * FINAL_EXAM_SCORE
        ),
        2
    ) AS WEIGHTED_ACADEMIC_SCORE

FROM STUDENT_DATA;

3. Create an engagement score using attendance, study habits and LMS activity

SELECT
    STUDENT_ID,
    GRADUATION_OUTCOME,

    ROUND(
        (
            0.5 * ATTENDANCE_RATE
            + 0.2 * STUDY_HOURS_PER_WEEK
            + 0.3 * LMS_LOGINS_PER_WEEK
        ),
        2
    ) AS ENGAGEMENT_INDEX

FROM STUDENT_DATA;

4. Categorise students based on engagement levels

SELECT
    STUDENT_ID,

    ROUND(
        (
            0.5 * ATTENDANCE_RATE
            + 0.2 * STUDY_HOURS_PER_WEEK
            + 0.3 * LMS_LOGINS_PER_WEEK
        ),
        2
    ) AS ENGAGEMENT_INDEX,

    CASE
        WHEN (
            0.5 * ATTENDANCE_RATE
            + 0.2 * STUDY_HOURS_PER_WEEK
            + 0.3 * LMS_LOGINS_PER_WEEK
        ) >= 75
        THEN 'HIGH'

        WHEN (
            0.5 * ATTENDANCE_RATE
            + 0.2 * STUDY_HOURS_PER_WEEK
            + 0.3 * LMS_LOGINS_PER_WEEK
        ) >= 50
        THEN 'MODERATE'

        ELSE 'LOW'
    END AS ENGAGEMENT_CATEGORY

FROM STUDENT_DATA;

5. Create the cumulative student risk score based on the following multiple warning indicators:
* Attendance rate
* LMS Logins per week
* Disciplinary record
* Part time job hours

SELECT
    STUDENT_ID,
    GRADUATION_OUTCOME,

    (
        CASE
            WHEN ATTENDANCE_RATE < 65 THEN 2
            ELSE 0
        END

        +

        CASE
            WHEN LMS_LOGINS_PER_WEEK < 5 THEN 2
            ELSE 0
        END

        +

        CASE
            WHEN DISCIPLINARY_RECORD = 'CRITICAL' THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN PART_TIME_JOB_HOURS > 20 THEN 1
            ELSE 0
        END

    ) AS RISK_SCORE

FROM STUDENT_DATA

ORDER BY RISK_SCORE DESC;

6. Business Context:
The university wants to identify students who may be
at risk of poor academic outcomes or potential dropout. Create a derived feature called RISK_FLAG based on attendance, disciplinary history, and academic performance indicators.

Risk Criteria:
A student is classified as HIGH RISK if:
- attendance_rate < 70 OR
- disciplinary_record = 'HIGH' OR
- average_assignment_score < 60
Otherwise classify the student as LOW RISK.

SELECT
    STUDENT_ID,
    GRADUATION_OUTCOME,
    CASE
        WHEN ATTENDANCE_RATE < 70
            OR DISCIPLINARY_RECORD = 'HIGH'
            OR AVERAGE_ASSIGNMENT_SCORE < 60
        THEN 'HIGH RISK'
        ELSE 'LOW RISK'
    END AS RISK_FLAG
FROM STUDENT_DATA;