# Loan Approval Data Cleaning & Exploratory Analysis

> SQL-based data cleaning and exploratory analysis to understand loan approval patterns and identify key factors influencing lending decisions

[![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)](https://www.mysql.com/)

## Business Problem

Financial institutions process thousands of loan applications but lack clear visibility into which applicant characteristics correlate with loan approvals. Without systematic analysis of historical data, lending decisions remain inconsistent and risk assessment stays subjective.

**The Challenge:**  
Raw loan datasets contained missing values, inconsistent categorical entries, and blank fields that prevented reliable analysis. The institution needed clean data to identify approval patterns and understand which factors (income, education, property area, marital status) influence loan decisions.

**The Solution:**  
End-to-end data pipeline: systematic SQL-based data cleaning to standardize all fields, followed by exploratory analysis uncovering approval trends, income patterns, and demographic correlations with loan outcomes.

---

## Technical Implementation

### Data Cleaning (MySQL)

**Datasets:**
- `loan_train`: Historical loan applications with approval status (used for analysis)
- `loan_test`: Future prediction dataset (cleaned for modeling)

**Challenges in Raw Data:**
- Blank string values (`''`) mixed with NULL values
- Inconsistent categorical entries ("Semiurban" vs "Semi-Urban")
- Missing values across multiple fields (Gender, Self_Employed, Credit_History)
- Incorrect data types (Loan_ID stored as INT instead of VARCHAR)

**Cleaning Process:**

**1. Created backup tables to preserve raw data**
```sql
CREATE TABLE loan_test_clean AS 
SELECT * FROM loan_test;

CREATE TABLE loan_train_clean AS
SELECT * FROM loan_train;
```

**2. Checked for duplicate records**
```sql
SELECT Loan_ID, COUNT(*) AS count
FROM loan_train_clean
GROUP BY Loan_ID
HAVING COUNT(*) > 1;
-- Result: No duplicates found
```

**3. Identified null/missing values across all columns**
```sql
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
  SUM(CASE WHEN Married IS NULL THEN 1 ELSE 0 END) AS null_married,
  SUM(CASE WHEN Dependents IS NULL THEN 1 ELSE 0 END) AS null_dependents,
  SUM(CASE WHEN Self_Employed IS NULL THEN 1 ELSE 0 END) AS null_self_employed,
  SUM(CASE WHEN Credit_History IS NULL THEN 1 ELSE 0 END) AS null_credit_history
FROM loan_train_clean;
```

**4. Standardized missing values by replacing blanks with NULL**
```sql
-- Gender column
UPDATE loan_train_clean
SET Gender = NULL
WHERE Gender = '';

-- Self_Employed column
UPDATE loan_train_clean
SET Self_Employed = NULL 
WHERE Self_Employed = '';

-- Credit_History column
UPDATE loan_test_clean
SET Credit_History = NULL 
WHERE Credit_History = '';
```

**5. Fixed inconsistent categorical values**
```sql
-- Standardized Property_Area spelling
UPDATE loan_train_clean
SET Property_Area = 'Semi-Urban'
WHERE Property_Area = 'Semiurban';
```

**6. Corrected data types**
```sql
-- Changed Loan_ID from INT to VARCHAR for proper handling
ALTER TABLE loan_train_clean
MODIFY Loan_ID VARCHAR(50);
```

**7. Verified categorical field values**
```sql
-- Verified Gender contains only 'Male', 'Female', or NULL
SELECT DISTINCT Gender FROM loan_train_clean;

-- Verified Married contains only 'Yes', 'No', or NULL
SELECT DISTINCT Married FROM loan_train_clean;

-- Verified Education contains only 'Graduate', 'Not Graduate'
SELECT DISTINCT Education FROM loan_train_clean;
```

**Output:**  
Clean, standardized datasets ready for analysis with:
- No duplicate records
- Consistent NULL handling across all fields
- Standardized categorical values
- Proper data types for all columns

---

### Exploratory Data Analysis (SQL)

**Key Business Questions Investigated:**

**1. Income Analysis**
```sql
-- Created Total_Income feature combining applicant + coapplicant income
SELECT *, 
    (ApplicantIncome + CoapplicantIncome) AS Total_income
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
```

**2. Loan Approval Patterns**
```sql
-- Overall approval rate
SELECT Loan_Status, 
    COUNT(*) AS count
FROM loan_train_clean
GROUP BY Loan_Status;

-- Average income comparison: Approved vs Rejected
SELECT Loan_Status,
    ROUND(AVG(ApplicantIncome + CoapplicantIncome), 2) AS avg_total_income
FROM loan_train_clean
GROUP BY Loan_Status;

-- Average loan amount: Approved vs Rejected
SELECT Loan_Status,
    ROUND(AVG(LoanAmount), 2) AS avg_loan_amount
FROM loan_train_clean
GROUP BY Loan_Status;
```

**3. Education Impact on Approvals**
```sql
SELECT Education,
    Loan_Status,
    COUNT(*) AS count
FROM loan_train_clean
WHERE Loan_Status = 'Y'
GROUP BY Education, Loan_Status
ORDER BY count DESC;
```

**4. Geographic Analysis**
```sql
-- Loan approvals by property area
SELECT Property_Area,
    Loan_Status,
    COUNT(*) AS count
FROM loan_train_clean
WHERE Loan_Status = 'Y'
GROUP BY Property_Area, Loan_Status
ORDER BY count DESC;

-- Average coapplicant income by property area
SELECT Property_Area,
    ROUND(AVG(CoapplicantIncome), 2) AS avg_coapplicant_income
FROM loan_test_clean
GROUP BY Property_Area
ORDER BY avg_coapplicant_income DESC;
```

**5. Marital Status Impact**
```sql
SELECT Married,
    Loan_Status,
    COUNT(*) AS count
FROM loan_train_clean
WHERE Loan_Status = 'Y'
GROUP BY Married, Loan_Status
ORDER BY count DESC;
```

**6. Income Distribution Analysis**
```sql
-- Overall income statistics
SELECT 
    MIN(ApplicantIncome) AS min_income,
    MAX(ApplicantIncome) AS max_income,
    AVG(ApplicantIncome) AS avg_income
FROM loan_test_clean;

-- Edge case: Applicants with zero income but coapplicant earns
SELECT *
FROM loan_test_clean
WHERE ApplicantIncome = 0;
```

---

## Key Findings

### Loan Approval Patterns

**Overall Approval Rate:**
- Approved loans (Y) significantly outnumber rejected loans (N)
- Indicates relatively high approval rate in historical data

**Income Correlation:**
- Approved applicants have higher average total income (Applicant + Coapplicant)
- Income is a strong predictor of loan approval
- Households with dual income (coapplicant contribution) show better approval rates

**Loan Amount Analysis:**
- Approved loans have lower average loan amounts compared to rejected ones
- Suggests risk aversion: larger loan requests face higher scrutiny
- Applicants requesting amounts proportional to income are more likely to be approved

### Education Impact

**Graduate vs Non-Graduate:**
- Graduates receive more loan approvals overall
- Education level correlates positively with approval likelihood
- Suggests education is used as a proxy for financial stability/earning potential

### Geographic Patterns

**Property Area Analysis:**
- Semi-Urban areas show highest approval counts
- Urban and Rural areas have different income profiles
- Property location influences both income levels and approval rates

**Coapplicant Income Variance:**
- Coapplicant income varies significantly by property area
- Urban areas tend to have higher dual-income households
- Geographic location affects household financial structure

### Marital Status Correlation

**Married vs Single Applicants:**
- Married applicants show higher approval rates
- Likely due to combined household income (coapplicant contribution)
- Marital status may signal financial stability to lenders

### Income Insights

**Income Distribution:**
- Wide income range across applicants
- Some applicants have zero personal income but rely on coapplicant earnings
- Total household income is better predictor than individual applicant income alone

**Education-Income Relationship:**
- Graduates show higher average total income
- Education level correlates with earning potential
- Income differences persist across property areas

---

## Data Quality Notes

**Missing Values:**
- Gender: Some records missing
- Self_Employed: Partial missing data
- Credit_History: Key field with some nulls (important for risk assessment)
- Loan_Amount_Term: Minor missing values

**Data Considerations:**
- Missing values standardized as NULL for consistent handling
- No duplicate loan IDs found in either dataset
- All categorical fields verified for consistency
- Data types corrected for proper analysis

---

## Project Structure

```
├── README.md
├── sql/
│   ├── data_cleaning.sql
│   └── exploratory_analysis.sql
├── data/
│   ├── loan_train_clean.csv
│   └── loan_test_clean.csv
└── screenshots/
    └── analysis_overview.png
```

---

## Data Source

Original dataset available on Kaggle:  
[Loan Prediction Problem Dataset](https://www.kaggle.com/datasets/altruistdelhite04/loan-prediction-problem-dataset)

---

## How to Use

**SQL Scripts:**
1. Run `data_cleaning.sql` to clean raw loan data
2. Execute `exploratory_analysis.sql` to generate insights
3. Cleaned CSV files available in `data/` folder for further analysis

**Next Steps:**
- Build predictive models using cleaned data
- Develop credit scoring system based on findings
- Create approval probability calculator
- Analyze credit history impact more deeply

---

## Business Applications

**For Lending Teams:**
- Identify high-risk loan applications early
- Understand which applicant characteristics predict approval
- Set data-driven lending criteria

**For Risk Management:**
- Quantify income thresholds for different loan amounts
- Assess geographic risk patterns
- Evaluate impact of missing credit history

**For Product Teams:**
- Design loan products targeted at specific demographics
- Optimize approval processes based on key predictors
- Improve customer experience by setting clear expectations

---

## Author

**Ayomide Gafar**  
Data Analyst  
📧 ayomidegafar79@gmail.com  
🐦 [@Suavetheprodigy](https://twitter.com/Suavetheprodigy)

---

*Clean data foundation for predictive loan approval modeling and risk assessment.*

