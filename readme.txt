# Loan Data Cleaning Project

## Overview
This project involves cleaning and preparing loan datasets (`loan_train` and `loan_test`) for analysis. The data was cleaned by handling missing values, standardizing categorical fields, and verifying duplicates.

## Data Source
The original data was sourced from [https://www.kaggle.com/datasets/altruistdelhite04/loan-prediction-problem-dataset?select=train_u6lujuX_CVtuZ9i.csv].

## Cleaning Steps
- Replaced blank values with NULL for consistency
- Verified no duplicate records exist
- Standardized categorical variables such as Gender and Property Area
- Checked and corrected data types where necessary

## How to Use
- Cleaned datasets are available in the `data` folder as CSV files.



- Cleaning SQL script is in the `scripts` folder.
- You can load these CSVs into any data analysis tool for exploration and modeling.

## Next Steps
Plan to perform detailed exploratory data analysis (EDA) and maybe build predictive models.




## Exploratory Data Analysis
- Uncovered patterns and insights from the cleaned loan dataset using SQL
- Explored total income analysis (Applicant + Coapplicant)
- Analyzed loan approval trends based on income and loan amount
- Investigated the impact of education and property area on loan approval
- Examined the correlation between marital status and loan approvals

## How to Use
- Exploration queries and detailed insights are in the `exploration.sql` file
