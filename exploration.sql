-- Exploratory Data Analysis (EDA)
-- Focus: Understanding patterns and approval trends in the loan dataset

-- Previewing cleaned test data
SELECT * FROM loan_test_clean;

-- Total number of rows in test data
SELECT COUNT(*) AS total_count FROM loan_test_clean;

-- Count distinct values for key categorical columns
SELECT COUNT(DISTINCT Gender) AS unique_genders FROM loan_test_clean;
SELECT COUNT(DISTINCT Married) AS unique_married_status FROM loan_test_clean;

-- Check completeness (non-null values) for important columns
SELECT 
    COUNT(*) AS total_rows,
    COUNT(Gender) AS gender_not_null,
    COUNT(Married) AS married_not_null,
    COUNT(ApplicantIncome) AS applicantIncome_not_null
FROM loan_test_clean;

-- Distribution of applicant income
SELECT 
    MIN(ApplicantIncome) AS min_income,
    MAX(ApplicantIncome) AS max_income,
    AVG(ApplicantIncome) AS avg_income
FROM loan_test_clean;

-- Rows where ApplicantIncome is 0 (but coapplicant earns)
SELECT *
FROM loan_test_clean
WHERE ApplicantIncome = 0;

-- Creating total income feature
SELECT *, (ApplicantIncome + CoapplicantIncome) AS Total_income
FROM loan_test_clean;

-- Average total income by education level
SELECT Education, 
    ROUND(AVG(ApplicantIncome + CoapplicantIncome), 2) AS avg_total_income
FROM loan_test_clean
GROUP BY Education;

-- Average total income by property area
SELECT Property_Area, 
    ROUND(AVG(ApplicantIncome + CoapplicantIncome), 2) AS avg_total_income
FROM loan_test_clean
GROUP BY Property_Area;

-- Average coapplicant income by property area
SELECT Property_Area,
       ROUND(AVG(CoapplicantIncome), 2) AS avg_coapplicant_income
FROM loan_test_clean
GROUP BY Property_Area
ORDER BY avg_coapplicant_income DESC;

-- ========== Loan Approval Trends ==========

-- Count of approved vs rejected loans
SELECT Loan_Status, 
    COUNT(*) AS count
FROM loan_train_clean
GROUP BY Loan_Status;

-- Average total income grouped by Loan_Status
SELECT Loan_Status,
    ROUND(AVG(ApplicantIncome + CoapplicantIncome), 2) AS avg_total_income
FROM loan_train_clean
GROUP BY Loan_Status;

-- Average loan amount grouped by Loan_Status
SELECT Loan_Status,
    ROUND(AVG(LoanAmount), 2) AS avg_loan_amount
FROM loan_train_clean
GROUP BY Loan_Status;

-- Loan approvals by education level
SELECT Education,
    Loan_Status,
    COUNT(*) AS count
FROM loan_train_clean
WHERE Loan_Status = 'Y'
GROUP BY Education, Loan_Status
ORDER BY count DESC;

-- Loan approvals by property area
SELECT Property_Area,
    Loan_Status,
    COUNT(*) AS count
FROM loan_train_clean
WHERE Loan_Status = 'Y'
GROUP BY Property_Area, Loan_Status
ORDER BY count DESC;

-- Loan approvals by marital status
SELECT Married,
    Loan_Status,
    COUNT(*) AS count
FROM loan_train_clean
WHERE Loan_Status = 'Y'
GROUP BY Married, Loan_Status
ORDER BY count DESC;
