
-- EXPLORATORY DATA ANALYSIS
-- Dataset: layoffs_staging2


-- 1. Preview dataset
SELECT *
FROM layoffs_staging2;

-- 2. Maximum layoffs and percentage laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- 3. Filter for percentage_laid_off = 1
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- 4. Total layoffs by company
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

-- 5. Min and max date
SELECT MIN(date), MAX(date)
FROM layoffs_staging2;

-- 6. Total layoffs by country
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

-- 7. Total layoffs by year
SELECT YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY total_laid_off DESC;

-- 8. Total layoffs by funding stage
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;

-- 9. Rolling total of layoffs per month
WITH Date_CTE AS (
    SELECT SUBSTRING(date,1,7) AS month, SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    GROUP BY month
)
SELECT month, SUM(total_off) OVER (ORDER BY month ASC) AS rolling_total_layoffs
FROM Date_CTE
ORDER BY month ASC;

-- 10. Top 3 companies with highest layoffs per year
WITH Company_Year AS (
    SELECT company, YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(date)
),
Company_Year_Rank AS (
    SELECT company, year, total_laid_off,
           DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS ranking
    FROM Company_Year
)
SELECT company, year, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
ORDER BY year ASC, total_laid_off DESC;
