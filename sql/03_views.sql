-- 1. SQL VIEWS FOR POWER BI

-- 1.1 HR Overview View

CREATE OR REPLACE VIEW vw_hr_overview AS

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

    ROUND(
        100.0 *
        SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS retention_rate,

    ROUND(AVG(Age), 1) AS average_age,

    ROUND(AVG(MonthlyIncome), 0) AS average_monthly_income,

    ROUND(AVG(YearsAtCompany), 1) AS average_years_at_company

FROM hr_attrition;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT *
FROM vw_hr_overview;

-- 1.2 Department Attrition View

CREATE OR REPLACE VIEW vw_department_attrition AS

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
        SUM(
            CASE
                WHEN Attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS attrition_rate

FROM hr_attrition

GROUP BY Department;

SELECT *
FROM vw_department_attrition
ORDER BY attrition_rate DESC;

-- 1.3 Job Role Attrition View

CREATE OR REPLACE VIEW vw_jobrole_attrition AS

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

    SUM(
        CASE
            WHEN Attrition = 'No' THEN 1
            ELSE 0
        END
    ) AS employees_stayed,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN Attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS attrition_rate,

    ROUND(AVG(MonthlyIncome), 0) AS average_monthly_income,

    ROUND(AVG(YearsAtCompany), 1) AS average_years_at_company

FROM hr_attrition

GROUP BY
    Department,
    JobRole;
    
    SELECT *
FROM vw_jobrole_attrition
ORDER BY attrition_rate DESC;

-- 1.4 Employee Factors View

CREATE OR REPLACE VIEW vw_employee_factors AS

SELECT

    Department,

    JobRole,

    Attrition,

    Age,

    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 35 THEN '25-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        ELSE 'Over 45'
    END AS age_group,

    MonthlyIncome,

    CASE
        WHEN MonthlyIncome < 3000 THEN 'Under 3K'
        WHEN MonthlyIncome BETWEEN 3000 AND 5999 THEN '3K-6K'
        WHEN MonthlyIncome BETWEEN 6000 AND 11999 THEN '6K-12K'
        ELSE '12K+'
    END AS salary_band,

    OverTime,

    JobSatisfaction,

    CASE
        WHEN JobSatisfaction = 1 THEN 'Low'
        WHEN JobSatisfaction = 2 THEN 'Medium'
        WHEN JobSatisfaction = 3 THEN 'High'
        WHEN JobSatisfaction = 4 THEN 'Very High'
    END AS satisfaction_label,

    WorkLifeBalance,

    CASE
        WHEN WorkLifeBalance = 1 THEN 'Bad'
        WHEN WorkLifeBalance = 2 THEN 'Good'
        WHEN WorkLifeBalance = 3 THEN 'Better'
        WHEN WorkLifeBalance = 4 THEN 'Best'
    END AS wlb_label,

    YearsAtCompany,

    YearsInCurrentRole,

    YearsSinceLastPromotion

FROM hr_attrition;

SELECT *
FROM vw_employee_factors
LIMIT 10;

-- 1.5 Career Progression View

CREATE OR REPLACE VIEW vw_career_progression AS

SELECT

    Department,

    JobRole,

    Attrition,

    YearsAtCompany,

    CASE
        WHEN YearsAtCompany < 2 THEN 'Less than 2 years'
        WHEN YearsAtCompany BETWEEN 2 AND 5 THEN '2-5 years'
        WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10 years'
        ELSE 'More than 10 years'
    END AS tenure_group,

    YearsInCurrentRole,

    CASE
        WHEN YearsInCurrentRole < 2 THEN 'Less than 2 years'
        WHEN YearsInCurrentRole BETWEEN 2 AND 4 THEN '2-4 years'
        WHEN YearsInCurrentRole BETWEEN 5 AND 7 THEN '5-7 years'
        ELSE 'More than 7 years'
    END AS current_role_tenure,

    YearsSinceLastPromotion,

    CASE
        WHEN YearsSinceLastPromotion = 0
            THEN 'Less than 1 year'
        WHEN YearsSinceLastPromotion BETWEEN 1 AND 2
            THEN '1-2 years'
        WHEN YearsSinceLastPromotion BETWEEN 3 AND 5
            THEN '3-5 years'
        ELSE 'More than 5 years'
    END AS promotion_gap

FROM hr_attrition;

SELECT *
FROM vw_career_progression
LIMIT 10;

-- 1.6 Validate Our SQL Views

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

DESCRIBE vw_career_progression;