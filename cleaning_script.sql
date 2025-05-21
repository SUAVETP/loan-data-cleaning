-- Creating database and importing files
-- loan_train: data with loan status
-- loan_test: future prediction dataset

CREATE DATABASE loan_project;
USE loan_project;

-- Creating backup copies of the original tables to preserve raw data.
-- All data cleaning and transformations will be performed on these copies.

CREATE TABLE loan_test_clean AS 
SELECT * FROM loan_test;

CREATE TABLE loan_train_clean AS
SELECT * FROM loan_train;

SELECT * FROM
loan_test_clean;

-- checkimg for duplicates

SELECT Loan_ID , COUNT(*) AS count
FROM loan_test_clean
GROUP BY Loan_ID
HAVING COUNT(*) > 1;



-- checking for null values 

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
  SUM(CASE WHEN Married IS NULL THEN 1 ELSE 0 END) AS null_married,
  SUM(CASE WHEN Dependents IS NULL THEN 1 ELSE 0 END) AS null_dependents,
  SUM(CASE WHEN Education IS NULL THEN 1 ELSE 0 END) AS null_education,
  SUM(CASE WHEN Self_Employed IS NULL THEN 1 ELSE 0 END) AS null_self_employed,
  SUM(CASE WHEN ApplicantIncome IS NULL THEN 1 ELSE 0 END) AS null_applicant_income,
  SUM(CASE WHEN CoapplicantIncome IS NULL THEN 1 ELSE 0 END) AS null_coapplicant_income,
  SUM(CASE WHEN LoanAmount IS NULL THEN 1 ELSE 0 END) AS null_loan_amount,
  SUM(CASE WHEN Loan_Amount_Term IS NULL THEN 1 ELSE 0 END) AS null_loan_term,
  SUM(CASE WHEN Credit_History IS NULL THEN 1 ELSE 0 END) AS null_credit_history
FROM loan_test_clean;


-- Replace blank ('') values in the Gender column with NULL 
-- to standardize missing or unknown gender entries for easier cleaning and analysis.


SELECT * 
FROM loan_test_clean;

SELECT DISTINCT Gender FROM loan_test_clean;

UPDATE loan_test_clean
SET Gender = NULL
WHERE Gender = '';

-- Verifing that the Married column contains only 'Yes' and 'No' values

SELECT * FROM loan_test_clean;

 SELECT
 DISTINCT Married
 FROM loan_test_clean;

-- Verifing that the Education column contains only 'Graduate' and 'Not Graduate' values

SELECT *
FROM loan_test_clean;

 SELECT
 DISTINCT Education
 FROM loan_test_clean;
 
 -- checked and Replace blank ('') values in the  Self_employed column with NULL 
 
SELECT *
FROM loan_test_clean;

 SELECT
 DISTINCT Self_Employed
 FROM loan_test_clean;
 
 UPDATE loan_test_clean
 SET Self_Employed = NULL 
 WHERE Self_Employed = '';
 
 -- Replaced blank values in Credit_History with NULL for consistent missing data handling
 
 SELECT *
FROM loan_test_clean;

 SELECT
 DISTINCT Credit_History
 FROM loan_test_clean;
 
 UPDATE loan_test_clean
 SET Credit_History = NULL 
 WHERE Credit_History = '';
 
 -- Verifing that the Property_Area column
 
SELECT *
FROM loan_test_clean;

 SELECT
 DISTINCT Property_Area
 FROM loan_test_clean;
 
 SELECT *
FROM loan_test_clean;


-- Describe the structure of the table 'loan_train_clean' to review column names, data types, and nullability
DESCRIBE loan_test_clean;


-- Changed loan_id data type from INT to VARCHAR

ALTER TABLE loan_test_clean
MODIFY Loan_ID VARCHAR(50);

SELECT *
FROM loan_train_clean;

-- Checking for duplicates
SELECT Loan_ID , COUNT(*) AS count
FROM loan_train_clean
GROUP BY Loan_ID
HAVING COUNT(*) > 1;


-- checking for Null values 

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
  SUM(CASE WHEN Married IS NULL THEN 1 ELSE 0 END) AS null_married,
  SUM(CASE WHEN Dependents IS NULL THEN 1 ELSE 0 END) AS null_dependents,
  SUM(CASE WHEN Education IS NULL THEN 1 ELSE 0 END) AS null_education,
  SUM(CASE WHEN Self_Employed IS NULL THEN 1 ELSE 0 END) AS null_self_employed,
  SUM(CASE WHEN ApplicantIncome IS NULL THEN 1 ELSE 0 END) AS null_applicant_income,
  SUM(CASE WHEN CoapplicantIncome IS NULL THEN 1 ELSE 0 END) AS null_coapplicant_income,
  SUM(CASE WHEN LoanAmount IS NULL THEN 1 ELSE 0 END) AS null_loan_amount,
  SUM(CASE WHEN Loan_Amount_Term IS NULL THEN 1 ELSE 0 END) AS null_loan_term,
  SUM(CASE WHEN Credit_History IS NULL THEN 1 ELSE 0 END) AS null_credit_history,
  sum(CASE WHEN Property_Area IS NULL THEN 1 ELSE 0 END) AS null_property_area,
  sum(CASE WHEN Loan_Status IS NULL THEN 1 ELSE 0 END) AS null_loan_status
FROM loan_train_clean;


-- Replacing blank ('') values in the Gender column with NULL 
-- to standardize missing or unknown gender entries for easier cleaning and analysis.

SELECT * FROM loan_train_clean;

SELECT 
DISTINCT Gender
FROM loan_train_clean;

UPDATE loan_train_clean
SET Gender = NULL
WHERE Gender = '';


-- Checked for distinct values in the 'Married' column to identify any blanks or inconsistencies.

SELECT * FROM loan_train_clean;

SELECT 
DISTINCT Married
FROM loan_train_clean;



-- Checked for distinct values in the 'Education' column to identify any blanks

SELECT * FROM loan_train_clean;

SELECT 
DISTINCT Education
FROM loan_train_clean;

-- Checked for distinct values in the 'Self_Employed' column to find any blank entries.
-- Replaced blank values ('') with NULL to standardize missing data representation.



SELECT * FROM loan_train_clean;


SELECT 
DISTINCT Self_Employed
FROM loan_train_clean;


UPDATE loan_train_clean
SET Self_Employed = NULL 
WHERE Self_Employed = '';

-- Checked for distinct values in the 'Property_Area' column.
-- Standardized spelling by updating 'Semiurban' to 'Semi-Urban' for consistency.


SELECT * FROM loan_train_clean;

SELECT 
DISTINCT Property_Area
FROM loan_train_clean;

UPDATE loan_train_clean
SET Property_Area = 'Semi-Urban'
WHERE Property_Area = 'Semiurban';

SELECT * FROM loan_train_clean;


-- Describe the structure of the table 'loan_train_clean' to review column names, data types, and nullability
DESCRIBE loan_train_clean;

-- Changed loan_id data type from INT to VARCHAR

ALTER TABLE loan_train_clean
MODIFY Loan_ID VARCHAR(50);
