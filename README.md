# Exploratory Data Analysis on Layoffs Dataset

## Overview

This repository contains SQL queries used for Exploratory Data Analysis (EDA) on the layoffs_staging3 dataset. The queries help analyze trends, patterns, and insights related to layoffs across different companies, industries, and time periods.

## Dataset

The dataset layoffs_staging3 includes information on layoffs, such as the number of employees laid off, percentage layoffs, company name, industry, funding raised, and stage of the company.

## SQL Queries & Analysis

### 1. Basic Exploration

Retrieve all records:

SELECT * FROM layoffs_staging3;

Find the maximum number of layoffs and percentage laid off:

SELECT MAX(total_laid_off), MAX(percentage_laid_off)  
FROM layoffs_staging3;


### 2. Companies with 100% Layoffs

Retrieve companies where all employees were laid off:

SELECT *  
FROM layoffs_staging3  
WHERE percentage_laid_off = 1;

Sort by highest total layoffs:

SELECT *  
FROM layoffs_staging3  
WHERE percentage_laid_off = 1  
ORDER BY total_laid_off DESC;

Sort by highest funds raised:

SELECT *  
FROM layoffs_staging3  
WHERE percentage_laid_off = 1  
ORDER BY funds_raised_millions DESC;


### 3. Layoff Trends by Company, Industry, and Year

Total layoffs by company (descending order):

SELECT company, SUM(total_laid_off)  
FROM layoffs_staging3  
GROUP BY company  
ORDER BY 2 DESC;

Date range of layoffs:

SELECT MIN(date), MAX(date)  
FROM layoffs_staging3;

Total layoffs by industry:

SELECT industry, SUM(total_laid_off)  
FROM layoffs_staging3  
GROUP BY industry  
ORDER BY 2 DESC;

Year-wise total layoffs:

SELECT YEAR(date), SUM(total_laid_off)  
FROM layoffs_staging3  
GROUP BY YEAR(date)  
ORDER BY 1 DESC;

Total layoffs by company stage:

SELECT stage, SUM(total_laid_off)  
FROM layoffs_staging3  
GROUP BY stage  
ORDER BY 1 DESC;


### 4. Layoff Percentage Analysis

Sum of percentage laid off by company:

SELECT company, SUM(percentage_laid_off)  
FROM layoffs_staging3  
GROUP BY company  
ORDER BY 1 DESC;

Average layoff percentage by company:

SELECT company, AVG(percentage_laid_off)  
FROM layoffs_staging3  
GROUP BY company  
ORDER BY 1 DESC;


### 5. Monthly Layoff Trends

Layoffs by month:

SELECT SUBSTRING(date,1,7) AS Month, SUM(total_laid_off)  
FROM layoffs_staging3  
WHERE SUBSTRING(date,1,7) IS NOT NULL  
GROUP BY Month  
ORDER BY 1 ASC;

Rolling total layoffs by month:

WITH Rolling_Total AS (  
    SELECT SUBSTRING(date,1,7) AS 'Month', SUM(total_laid_off) AS total_off  
    FROM layoffs_staging3  
    WHERE SUBSTRING(date,1,7) IS NOT NULL  
    GROUP BY 'Month'  
    ORDER BY 1 ASC  
)  
SELECT 'Month', total_off, SUM(total_off) OVER (ORDER BY 'Month') AS rolling_total  
FROM Rolling_Total;


### 6. Yearly Layoffs by Company

Total layoffs by company and year:

SELECT company, YEAR(date), SUM(total_laid_off)  
FROM layoffs_staging3  
GROUP BY company, YEAR(date)  
ORDER BY company ASC;

Top 5 companies with highest layoffs per year:

WITH Company_Year (Company, Year, total_laid_off) AS (  
    SELECT company, YEAR(date), SUM(total_laid_off)  
    FROM layoffs_staging3  
    GROUP BY company, YEAR(date)  
),  
company_year_rank AS (  
    SELECT *, DENSE_RANK() OVER (PARTITION BY Year ORDER BY total_laid_off DESC) AS Ranking  
    FROM Company_Year  
    WHERE Year IS NOT NULL  
)  
SELECT *  
FROM company_year_rank  
WHERE Ranking <= 5;


