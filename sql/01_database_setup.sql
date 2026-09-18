-- HR Employee Attrition Analysis
-- Database and table setup

CREATE DATABASE analytics;
USE analytics;

CREATE TABLE hr_attrition (
  Age INTEGER,
  Attrition TEXT,
  BusinessTravel TEXT,
  DailyRate INTEGER,
  Department TEXT,
  DistanceFromHome INTEGER,
  Education INTEGER,
  EnvironmentSatisfaction INTEGER,
  Gender TEXT,
  JobRole TEXT,
  JobSatisfaction INTEGER,
  MaritalStatus TEXT,
  MonthlyIncome INTEGER,
  NumCompaniesWorked INTEGER,
  OverTime TEXT,
  PercentSalaryHike INTEGER,
  PerformanceRating INTEGER,
  WorkLifeBalance INTEGER,
  YearsAtCompany INTEGER,
  YearsInCurrentRole INTEGER,
  YearsSinceLastPromotion INTEGER
);