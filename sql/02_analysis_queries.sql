-- 1. DATASET UNDERSTANDING
-- 1.1 Total Number of Employees

SELECT
    COUNT(*) AS total_employees
FROM hr_attrition;

-- 1.2 Sample Records

SELECT *
FROM hr_attrition
LIMIT 10;

-- 1.3 Overall attrition rate

SELECT
  COUNT(*) AS total_employees,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_company,
  ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM hr_attrition;

-- 2. DATA QUALITY CHECKS

-- 2.1 Missing Value Check

SELECT
    COUNT(*) AS total_records,

    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END) AS missing_attrition,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS missing_department,
    SUM(CASE WHEN JobRole IS NULL THEN 1 ELSE 0 END) AS missing_job_role,
    SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS missing_income,
    SUM(CASE WHEN OverTime IS NULL THEN 1 ELSE 0 END) AS missing_overtime

FROM hr_attrition;

-- 2.2 Attrition Category Check

SELECT
    Attrition,
    COUNT(*) AS employees
FROM hr_attrition
GROUP BY Attrition;

-- 3. OVERALL HR KPIs

-- 3.1 Overall HR Workforce Summary

-- Business Question:
-- What does the overall employee attrition situation look like?

SELECT
    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    SUM(
        CASE
            WHEN Attrition = 'No' THEN 1
            ELSE 0
        END
    ) AS employees_stayed,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate,

    ROUND(AVG(Age), 1) AS average_age,

    ROUND(AVG(MonthlyIncome), 0) AS average_monthly_income,

    ROUND(AVG(YearsAtCompany), 1) AS average_years_at_company

FROM hr_attrition;

-- 3.2 Employee Retention Rate
-- Business Question:
-- What percentage of employees remained with the company?

SELECT
    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS retention_rate
FROM hr_attrition;

-- Initial Observation:

-- The dataset contains 1,470 employees, of whom 237 
-- have left the organization.
-- The overall attrition rate is approximately 16.1%.


-- 4. DEPARTMENT ANALYSIS

-- 4.1 Attrition by Department

-- Business Question:
-- Which departments have the highest attrition?

SELECT
    Department,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    SUM(
        CASE
            WHEN Attrition = 'No' THEN 1
            ELSE 0
        END
    ) AS employees_stayed,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM hr_attrition

GROUP BY Department

ORDER BY attrition_rate DESC;

-- 4.2 Department contribution to total exits

-- Business Question:
-- Which departments account for the largest number of employee exits?

SELECT
    Department,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / (
            SELECT COUNT(*)
            FROM hr_attrition
            WHERE Attrition = 'Yes'
        ),
        2
    ) AS share_of_total_exits

FROM hr_attrition

GROUP BY Department

ORDER BY employees_left DESC;

-- 4.3 Department vs Company benchmark

-- Business Question:
-- Which departments have attrition above the company-wide attrition rate?

SELECT
    Department,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate,

    ROUND(
        (
            100.0 *
            SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
            / COUNT(*)
        ) - 16.12,
        2
    ) AS difference_from_company_rate

FROM hr_attrition

GROUP BY Department

ORDER BY attrition_rate DESC;

-- 5. JOB ROLE ANALYSIS

-- 5.1 Attrition by Job Role

-- Business Question:
-- Which job roles have the highest attrition?

SELECT
    JobRole,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM hr_attrition

GROUP BY JobRole

ORDER BY attrition_rate DESC;

-- 5.2 Department + Job Role

-- Business Question:
-- Which job roles within each department have the highest attrition?

SELECT
    Department,
    JobRole,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM hr_attrition

GROUP BY
    Department,
    JobRole

ORDER BY
    attrition_rate DESC;
    
-- 5.3 Job Role + Overtime

-- Business Question:
-- Does the relationship between overtime and attrition differ across job roles?

SELECT
    JobRole,
    OverTime,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM hr_attrition

GROUP BY
    JobRole,
    OverTime

ORDER BY
    JobRole,
    attrition_rate DESC;
    
-- 6. EMPLOYEE FACTORS

-- 6.1 Age & Attrition

-- Business Question:
-- Which age groups have the highest observed attrition?

SELECT

    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 35 THEN '25-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        ELSE 'Over 45'
    END AS age_group,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM hr_attrition

GROUP BY
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 35 THEN '25-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        ELSE 'Over 45'
    END

ORDER BY attrition_rate DESC;

-- 6.2 Overtime & Attrition

-- Business Question:
-- How does overtime status relate to employee attrition?

SELECT
    OverTime,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    SUM(
        CASE
            WHEN Attrition = 'No' THEN 1
            ELSE 0
        END
    ) AS employees_stayed,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM hr_attrition

GROUP BY OverTime

ORDER BY attrition_rate DESC;

-- 6.3 Job Satisfaction & Attrition

-- Business Question:
-- Is job satisfaction associated with different levels of employee attrition?

SELECT
    JobSatisfaction,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM hr_attrition

GROUP BY JobSatisfaction

ORDER BY JobSatisfaction;

-- 6.4 Work-Life Balance & Attrition

-- Business Question:
-- Is work-life balance associated with different levels of employee attrition?

SELECT
    WorkLifeBalance,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM hr_attrition

GROUP BY WorkLifeBalance

ORDER BY WorkLifeBalance;

-- 7 COMPENSATION ANALYSIS

-- 7.1 Salary Band Analysis

-- Business Question:
-- How does attrition vary across different income levels?

WITH salary_banded AS (
    SELECT *,
        CASE
            WHEN MonthlyIncome < 3000                      THEN 'Low (under 3k)'
            WHEN MonthlyIncome BETWEEN 3000 AND 6000        THEN 'Mid (3k-6k)'
            WHEN MonthlyIncome BETWEEN 6000.01 AND 12000    THEN 'Upper Mid (6k-12k)'
            ELSE 'High (12k+)'
        END AS salary_band
    FROM hr_attrition
)
SELECT
    salary_band,
    COUNT(*)                                                        AS employees,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM salary_banded
GROUP BY salary_band
ORDER BY attrition_pct DESC;

-- 7.2 Salary Band + Overtime
-- Business Question:
-- Does the relationship between compensation and attrition
-- differ between employees who work overtime and those
-- who do not?

SELECT

    CASE
        WHEN MonthlyIncome < 3000 THEN 'Under 3K'
        WHEN MonthlyIncome BETWEEN 3000 AND 5999 THEN '3K-6K'
        WHEN MonthlyIncome BETWEEN 6000 AND 11999 THEN '6K-12K'
        ELSE '12K+'
    END AS salary_band,

    OverTime,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM hr_attrition

GROUP BY
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Under 3K'
        WHEN MonthlyIncome BETWEEN 3000 AND 5999 THEN '3K-6K'
        WHEN MonthlyIncome BETWEEN 6000 AND 11999 THEN '6K-12K'
        ELSE '12K+'
    END,
    OverTime

ORDER BY
    salary_band,
    attrition_rate DESC;

-- 8. CAREER PROGRESSION

-- 8.1 Years at Company & Attrition

-- Business Question:
-- How does attrition vary across different levels of
-- employee tenure?

WITH tenure_analysis AS (

    SELECT
        CASE
            WHEN YearsAtCompany < 2 THEN 'Less than 2 years'
            WHEN YearsAtCompany BETWEEN 2 AND 5 THEN '2-5 years'
            WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10 years'
            ELSE 'More than 10 years'
        END AS tenure_group,

        Attrition

    FROM hr_attrition
)

SELECT
    tenure_group,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM tenure_analysis

GROUP BY tenure_group

ORDER BY attrition_rate DESC;

-- 8.3 Years Since Last Promotion

-- Business Question:
-- Is a longer gap since an employee's last promotion
-- associated with higher attrition?

WITH promotion_analysis AS (

    SELECT

        CASE
            WHEN YearsSinceLastPromotion = 0
                THEN 'Less than 1 year'

            WHEN YearsSinceLastPromotion BETWEEN 1 AND 2
                THEN '1-2 years'

            WHEN YearsSinceLastPromotion BETWEEN 3 AND 5
                THEN '3-5 years'

            ELSE 'More than 5 years'
        END AS promotion_gap,

        CASE
            WHEN YearsSinceLastPromotion = 0 THEN 1
            WHEN YearsSinceLastPromotion BETWEEN 1 AND 2 THEN 2
            WHEN YearsSinceLastPromotion BETWEEN 3 AND 5 THEN 3
            ELSE 4
        END AS promotion_order,

        Attrition

    FROM hr_attrition
)

SELECT

    promotion_gap,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN Attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS attrition_rate

FROM promotion_analysis

GROUP BY
    promotion_gap,
    promotion_order

ORDER BY
    promotion_order;