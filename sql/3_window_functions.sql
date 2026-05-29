1. Who are the top performing students within each gender group? Rank students within each gender category based on a weighted academic score using the following:
30% Assignment Score
30% Midterm Score
40% Final Exam Score

SELECT
    STUDENT_ID,
    GENDER,
    ROUND(
        (
            0.3 * AVERAGE_ASSIGNMENT_SCORE
            + 0.3 * MIDTERM_EXAM_SCORE
            + 0.4 * FINAL_EXAM_SCORE
        ),
        2
    ) AS WEIGHTED_SCORE,

    RANK() OVER (
        PARTITION BY GENDER
        ORDER BY
            (
                0.3 * AVERAGE_ASSIGNMENT_SCORE
                + 0.3 * MIDTERM_EXAM_SCORE
                + 0.4 * FINAL_EXAM_SCORE
            ) DESC
    ) AS PERFORMANCE_RANK
FROM STUDENT_DATA;

2. Who are the highest-risk students within each graduation outcome category? Rank students by risk score within each graduation outcome group.

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
    ) AS RISK_SCORE,

    RANK() OVER (
        PARTITION BY GRADUATION_OUTCOME
        ORDER BY
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
            ) DESC
    ) AS RISK_RANK

FROM STUDENT_DATA;

3. Who are the most engaged students within each graduation category? Rank students by engagement score within each graduation outcome.

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
    ) AS ENGAGEMENT_SCORE,

    RANK() OVER (
        PARTITION BY GRADUATION_OUTCOME
        ORDER BY
            (
                0.5 * ATTENDANCE_RATE
                + 0.2 * STUDY_HOURS_PER_WEEK
                + 0.3 * LMS_LOGINS_PER_WEEK
            ) DESC
    ) AS ENGAGEMENT_RANK
FROM STUDENT_DATA;

4. Assign a unique row number to students within each gender based on final exam performance.

SELECT
    STUDENT_ID,
    GENDER,
    FINAL_EXAM_SCORE,

    ROW_NUMBER() OVER (
        PARTITION BY GENDER
        ORDER BY FINAL_EXAM_SCORE DESC
    ) AS ROW_NUM
FROM STUDENT_DATA;

5. Identify the top 3 students within each gender.

WITH PERFORMANCE_RANKING AS (
    SELECT
        STUDENT_ID,
        GENDER,
        (
            0.3 * AVERAGE_ASSIGNMENT_SCORE
            + 0.3 * MIDTERM_EXAM_SCORE
            + 0.4 * FINAL_EXAM_SCORE
        ) AS WEIGHTED_SCORE,

        ROW_NUMBER() OVER (
            PARTITION BY GENDER
            ORDER BY
                (
                    0.3 * AVERAGE_ASSIGNMENT_SCORE
                    + 0.3 * MIDTERM_EXAM_SCORE
                    + 0.4 * FINAL_EXAM_SCORE
                ) DESC
        ) AS RN
    FROM STUDENT_DATA

)

SELECT *
FROM PERFORMANCE_RANKING
WHERE RN <= 3;