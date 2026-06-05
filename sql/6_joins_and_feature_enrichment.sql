1. Determine whether scholarship recipients obtain better employment outcomes after graduation.

I utilised the tables named below. Find tables in the data folder:
- STUDENT_DATA
- STUDENT_CAREER
- STUDENT_SCHOLARSHIP


SELECT
    SD.STUDENT_ID,
    SD.SOCIO_ECONOMIC_SCORE,
    SD.FINAL_EXAM_SCORE,
    SS.SCHOLARSHIP_TYPE,
    SC.EMPLOYMENT_STATUS,
    SC.STARTING_SALARY
FROM STUDENT_DATA SD
INNER JOIN STUDENT_CAREER SC
    ON SD.STUDENT_ID = SC.STUDENT_ID
INNER JOIN STUDENT_SCHOLARSHIP SS
    ON SC.STUDENT_ID = SS.STUDENT_ID;


2. Return all students, including those who did not receive scholarships.

I utilise the LEFT JOIN function to preserve all students from STUDENT_DATA.

SELECT
    SD.STUDENT_ID,
    SD.GRADUATION_OUTCOME,
    SS.SCHOLARSHIP_TYPE,
    SS.SCHOLARSHIP_ELIGIBLE
FROM STUDENT_DATA SD
LEFT JOIN STUDENT_SCHOLARSHIP SS
    ON SD.STUDENT_ID = SS.STUDENT_ID;


3. Identify scholarship recipients whose starting salary is at least £10,000 above the average salary
of others receiving the same scholarship type.

I utilise the Inner join function, as well as window functions and some feature engineering

WITH SCHOLARSHIP_STATS AS (
    SELECT
        SS.STUDENT_ID,
        SS.SCHOLARSHIP_TYPE,
        SC.STARTING_SALARY,
        AVG(SC.STARTING_SALARY)
            OVER (
                PARTITION BY SS.SCHOLARSHIP_TYPE
            ) AS SCHOLARSHIP_TYPE_AVG_SALARY
    FROM STUDENT_SCHOLARSHIP SS
    INNER JOIN STUDENT_CAREER SC
        ON SS.STUDENT_ID = SC.STUDENT_ID
)

SELECT
    STUDENT_ID,
    SCHOLARSHIP_TYPE,
    STARTING_SALARY,
    SCHOLARSHIP_TYPE_AVG_SALARY,
    STARTING_SALARY - SCHOLARSHIP_TYPE_AVG_SALARY AS DIFFERENCE
FROM SCHOLARSHIP_STATS
WHERE STARTING_SALARY >= SCHOLARSHIP_TYPE_AVG_SALARY + 10000
ORDER BY DIFFERENCE DESC;