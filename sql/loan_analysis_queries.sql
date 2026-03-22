CREATE DATABASE lending_project;
USE lending_project;

CREATE TABLE loans (
loan_amnt INT,
term_in_months INT,
int_rate FLOAT,
grade CHAR,
emp_length VARCHAR(20),
home_owner VARCHAR(30),
annual_inc INT,
loan_status VARCHAR(30),
purpose VARCHAR(30),
dti FLOAT,
fico_range_low INT,
fico_range_high INT,
decision VARCHAR(20),
credit_score INT,
risk_segment VARCHAR(20), 
loan_to_income FLOAT
);

SELECT * FROM loans;

# Used Table import Wizard to load the cleaned dataset "lending_clean.csv" from process of analysis by Python 
	
SELECT COUNT(*) FROM loans;    
				
SELECT * FROM loans LIMIT 10;

# 1. Approval Rate
-- Objective : To determine the overall loan approval rate

SELECT decision, COUNT(*) AS Count, ROUND((COUNT(*)*100) / (SELECT COUNT(*) FROM loans),2) AS Percentage
FROM loans
GROUP BY decision; 
     
-- Insight : A noticeable proportion of approved loans belong to high-risk segments, highlighting opportunities to improve risk-based decision-making.          

# 2. Factors driving Approval
-- Objective : To analyze how key financial factors such as credit score, income, and DTI differ between approved and rejected applications.

SELECT Decision, ROUND(AVG(credit_score)) AS Credit_Score, ROUND(AVG(annual_inc)) AS Annual_Income, ROUND(AVG(dti)) AS DTI
FROM loans
GROUP BY decision;

-- Insight: Loan approval is influenced by multiple financial factors rather than a single variable, highlighting the importance of a combined assessment of borrower creditworthiness.

# 3. Are higher Loan maount Riskier?
-- Objective : To evaluate whether higher loan amounts are associated with increased borrower risk.

SELECT Decision, ROUND(AVG(LOAN_AMNT)) AS Avg_Loan_Amount
FROM loans
GROUP BY Decision;

SELECT Decision, ROUND(AVG(LOAN_AMNT/ANNUAL_INC*100),2) AS Loan_Amount_To_Income_Ratio
FROM loans
GROUP BY decision;

-- Insight : Loan amount alone does not significantly determine borrower's risk, loan amount to income ratio is better to get the estimates.

# 4. Decision vs Risk
-- Objective : To compare actual loan decisions with calculated risk segments and identify mismatches in lending outcomes.

SELECT Decision, Risk_segment, ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER (PARTITION BY decision)) AS Percentage
FROM loans
GROUP BY decision, risk_segment;

-- Insight : A noticeable proportion of approved loans belong to high-risk segments, highlighting opportunities to improve risk-based decision-making.
