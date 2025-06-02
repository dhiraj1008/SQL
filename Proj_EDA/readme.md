
# 📈 Layoffs Data: Exploratory Data Analysis (EDA) with SQL

This repository provides SQL queries for performing an Exploratory Data Analysis (EDA) on employee layoff data. The goal of this project is to uncover trends, patterns, and interesting insights, including outliers, within workforce reduction events. By working through these queries, you'll gain practical experience in:

* **Identifying trends and patterns** in workforce data.
* **Communicating data-driven insights** and recommendations effectively.

---

## 📊 Dataset

This EDA is performed on a pre-cleaned dataset, assumed to be available in a table named `layoffs__staging2`. This table contains detailed information about company layoffs.

---

## ✨ EDA Queries & Insights

Here's a breakdown of the SQL queries used for the exploratory data analysis, along with the insights they reveal:

### 1. Data Overview

First, let's get a general sense of our data.

```sql
SELECT * FROM layoffs__staging2;
```

---

### 2. Peak Layoff Instances

Identify the highest number of layoffs that occurred at a single time and pinpoint the company responsible for the largest single layoff event.

```sql
-- Maximum single layoff count
SELECT MAX(total_laid_off) FROM layoffs__staging2;

-- Company with the highest single layoff event
SELECT company, MAX(total_laid_off)
FROM layoffs__staging2
GROUP BY company
ORDER BY MAX(total_laid_off) DESC
LIMIT 1;
```

---

### 3. Impact of 100% Layoffs

Explore the scale of layoffs when a company completely shut down or laid off its entire workforce (`percentage_laid_off = 1`).

```sql
-- Maximum 'total_laid_off' where 100% of employees were laid off
SELECT MAX(total_laid_off)
FROM layoffs__staging2
WHERE percentage_laid_off = 1;

-- All companies with 100% layoffs, ordered by the number of total laid off
SELECT *
FROM layoffs__staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;
```

---

### 4. Overall Layoff Scale

Understand the range of layoff percentages in the dataset.

```sql
-- Minimum and maximum percentage of layoffs
SELECT MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM layoffs__staging2;
```

---

### 5. Total Layoffs by Company

Identify which companies have experienced the most overall layoffs.

```sql
SELECT company, SUM(total_laid_off)
FROM layoffs__staging2
GROUP BY company
ORDER BY 2 DESC;
```

---

### 6. Layoff Timeframe

Determine the earliest and latest dates of layoffs recorded in the dataset.

```sql
SELECT MIN(`date`), MAX(`date`)
FROM layoffs__staging2;
```

---

### 7. Total Layoffs by Industry

Discover which industries have been most affected by layoffs.

```sql
SELECT industry, SUM(total_laid_off)
FROM layoffs__staging2
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY industry DESC;
```
**Note on execution flow**: When running this query, the database processes it in a specific order:
* **Table Access** (`FROM`): The `layoffs__staging2` table is accessed.
* **Row Filtering** (`WHERE`): Rows with a `NULL` industry are removed.
* **Grouping** (`GROUP BY`): Remaining rows are grouped by `industry`.
* **Aggregation** (`SUM`): The `total_laid_off` is summed for each `industry` group.
* **Column Selection** (`SELECT`): The `industry` and aggregated sum are selected.
* **Result Sorting** (`ORDER BY`): The final results are sorted by `industry` in descending order.

---

### 8. Total Layoffs by Country

Identify which countries have experienced the most overall layoffs.

```sql
SELECT country, SUM(total_laid_off) AS total_layoffs
FROM layoffs__staging2
GROUP BY country
HAVING SUM(total_laid_off) IS NOT NULL
ORDER BY 2 DESC;
```

---

### 9. Layoff Trends Over Time (Yearly & Monthly)

Analyze layoff trends by year and month to spot patterns or periods of increased activity.

```sql
-- Total layoffs by year
SELECT YEAR(`date`) AS `year`, SUM(total_laid_off)
FROM layoffs__staging2 AS ls2
WHERE `date` IS NOT NULL
GROUP BY `year`
ORDER BY 1;

-- Total layoffs by month (YYYY-MM format)
SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off)
FROM layoffs__staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC;
```

---

### 10. Rolling Total of Layoffs Per Month

Visualize the cumulative impact of layoffs over time using a rolling sum.

```sql
WITH Rolling_Total AS (
    SELECT
        SUBSTRING(`date`, 1, 7) AS `month`,
        SUM(total_laid_off) AS total_off
    FROM
        layoffs__staging2
    WHERE
        SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY
        `month`
    ORDER BY
        1 ASC
)
SELECT
    `month`,
    total_off,
    SUM(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM
    Rolling_Total;
```

---

### 11. Top Companies by Layoffs Each Year

Identify the top 5 companies with the highest layoff totals within each specific year.

```sql
WITH CompanyLayoffRank AS (
    SELECT
        Company,
        YEAR(date) AS layoff_year,
        SUM(total_laid_off) AS total_laid_off_yearly,
        ROW_NUMBER() OVER (PARTITION BY YEAR(date) ORDER BY SUM(total_laid_off) DESC) AS rn
    FROM
        layoffs__staging2
    WHERE
        total_laid_off IS NOT NULL
        AND date IS NOT NULL
    GROUP BY
        Company,
        YEAR(date)
)
SELECT
    Company,
    layoff_year,
    total_laid_off_yearly
FROM
    CompanyLayoffRank
WHERE
    rn <= 5
ORDER BY
    layoff_year DESC, total_laid_off_yearly DESC;
```

---

This set of queries provides a robust foundation for understanding the layoff landscape captured in your dataset.?
