---

# 🚀 Layoffs Data Cleaning Project 🧹✨

This repository houses a comprehensive SQL script for meticulously cleaning the Layoffs 2022 dataset. Our goal is to transform raw, messy data into a clean, standardized, and usable format ready for in-depth analysis.

---

## 📊 Dataset

The dataset used in this project is the **Layoffs 2022** collection, which can be downloaded directly from Kaggle:

➡️ [**Download the Layoffs 2022 Dataset from Kaggle**](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

---

## 🎯 Project Goals

The data cleaning process adheres to a structured approach, focusing on four key areas:

1.  **Duplicate Removal**: Identifying and eliminating redundant entries to ensure data uniqueness.
2.  **Data Standardization**: Fixing inconsistencies and standardizing various data points across columns.
3.  **Null & Blank Value Handling**: Strategically managing missing or empty values to maintain data integrity.
4.  **Unnecessary Data Removal**: Eliminating irrelevant columns or rows that do not contribute to the analysis.

---

## 🛠️ SQL Cleaning Steps

Below is a detailed breakdown of the SQL script, explaining each phase of the data cleaning process.

### 1. Database Setup & Staging 🏗️

First, we prepare our environment by activating the target database and creating a staging table. This approach ensures that our original raw data remains untouched, providing a safe sandbox for all cleaning operations.

```sql
-- Activating the database
USE layoffs_world;

-- Viewing the raw data
SELECT * FROM layoffs;

-- Creating a staging table with the same structure as the original
CREATE TABLE layoffs_staging
LIKE layoffs;

-- Inserting data into the staging table
INSERT layoffs_staging
SELECT * FROM layoffs;
```

### 2. Duplicate Removal 🚫

This crucial step identifies and removes duplicate rows. Since the original table lacks a unique identifier, we leverage the `ROW_NUMBER()` window function to pinpoint true duplicates based on all columns.

```sql
-- Checking for duplicates using ROW_NUMBER() over all columns
SELECT *
FROM (
    SELECT
        company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM
        layoffs_staging
) duplicates
WHERE
    row_num > 1;

-- To effectively delete duplicates, we create a new staging table with a 'row_num' column
CREATE TABLE `Layoffs__Staging2` (
    `company` text,
    `location` text,
    `industry` text,
    `total_laid_off` INT,
    `percentage_laid_off` text,
    `date` text,
    `stage` text,
    `country` text,
    `funds_raised_millions` int,
    row_num INT
);

-- Inserting data along with the calculated row_num into the new staging table
INSERT INTO layoffs__staging2
(`company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, `date`, `stage`, `country`, `funds_raised_millions`, `row_num`)
SELECT
    `company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, `date`, `stage`, `country`, `funds_raised_millions`,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
FROM
    layoffs_staging;

-- Deleting actual duplicate rows (where row_num is 2 or greater)
DELETE FROM layoffs__staging2
WHERE row_num >= 2;

-- Verifying duplicates are removed
SELECT *
FROM layoffs__staging2
WHERE row_num > 1; -- Should return an empty set
```

### 3. Data Standardization 🔄

This phase focuses on correcting inconsistencies and standardizing data formats across different columns, ensuring uniformity and accuracy.

#### **Company Names**

Trimming leading/trailing spaces for consistency.

```sql
UPDATE layoffs__staging2
SET company = TRIM(company);
```

#### **Industry Names**

Consolidating similar industry names (e.g., 'Crypto Currency' and 'CryptoCurrency' into 'Crypto').

```sql
SELECT DISTINCT industry FROM layoffs__staging2 ORDER BY 1;

UPDATE layoffs__staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry FROM layoffs__staging2 ORDER BY 1;
```

#### **Country Names**

Standardizing country names by removing extraneous characters (e.g., 'United States.' to 'United States').

```sql
SELECT DISTINCT country FROM layoffs__staging2 ORDER BY 1;

UPDATE layoffs__staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country FROM layoffs__staging2 ORDER BY 1;
```

#### **Date Format**

Converting the `date` column from text to a proper `DATE` format for easier chronological analysis.

```sql
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y') FROM layoffs__staging2;

UPDATE layoffs__staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs__staging2
MODIFY COLUMN `date` DATE;
```

### 4. Handling Null & Blank Values 🚮

Addressing missing values to ensure the dataset is complete and reliable.

```sql
-- Replacing empty industry strings with NULL for consistent handling
UPDATE layoffs__staging2
SET industry = NULL
WHERE industry = '';

-- Attempting to populate NULL industries by joining with other records of the same company
UPDATE layoffs__staging2 t1
JOIN layoffs__staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Verifying remaining NULL/blank industries (e.g., 'Bally's Interactive' might remain NULL if no other entry exists)
SELECT * FROM layoffs__staging2
WHERE industry IS NULL OR industry = '';

-- Deleting rows where both 'total_laid_off' and 'percentage_laid_off' are NULL, as these rows lack critical information
DELETE FROM layoffs__staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Verifying deletion
SELECT * FROM layoffs__staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; -- Should return an empty set
```

### 5. Removing Unnecessary Columns/Tables 🗑️

Finally, we remove any temporary columns or staging tables that are no longer needed after the cleaning process, leaving only the polished dataset.

```sql
-- Dropping the temporary 'row_num' column
ALTER TABLE layoffs__staging2
DROP COLUMN row_num;

-- (Optional) Dropping previous staging tables if no longer needed
-- DROP TABLE layoffs_staging;
-- DROP TABLE layoffs_staging_p1; -- (If such a table was created during initial experimentation)
```

---

## ✨ Final Cleaned Data

The `layoffs__staging2` table now contains the cleaned and standardized data, ready for further analysis and insights!

```sql
SELECT * FROM layoffs__staging2;
```

---

## 📈 Example Analysis (Post-Cleaning)

After the cleaning process, you can easily perform analytical queries. For instance, to find companies that raised significant funds and still had layoffs:

```sql
SELECT company, location, industry, funds_raised_millions
FROM layoffs__staging2
WHERE funds_raised_millions > 200;
```

---

This cleaned dataset provides a robust foundation for deeper exploration into layoff trends, industry impacts, and company-specific events.

---
