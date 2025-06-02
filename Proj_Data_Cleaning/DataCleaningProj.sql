-- SQL Project - Data Cleaning

-- data-set from this link you could download 
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

-- Activating the database on which work is going to be done--

use layoffs_world;


select * 
from layoffs;          

-- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens

create table layoffs_staging
like layoffs; 

select * from layoffs_staging;

-- inserting data into 'layoffs_staging' table from 'layoffs' table.

insert layoffs_staging 
select * from layoffs;

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and blank one 
-- 4. remove any columns and rows that are not necessary - few ways

-- 1. Remove Duplicates
## 1. Removing Duplicates ##

-- checking for the duplicates rows using row_number and over functions as we do not have any unique key in the data

SELECT *
FROM layoffs_staging
;

SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM 
		layoffs_staging;



SELECT *
FROM (
	SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`
			) AS row_num
	FROM 
		layoffs_staging
) duplicates
WHERE 
	row_num > 1;
    


-- let's just look at oda to confirm
SELECT *
FROM layoffs_staging
WHERE company = 'Oda';

-- it looks like these are all legitimate entries and shouldn't be deleted. We need to really look at every single row to be accurate

-- these are our real duplicates 

SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
	        layoffs_staging
) duplicates
WHERE 
	row_num > 1;
    
    
-- these are the ones we want to delete where the row number is > 1 or 2 or greater essentially

-- now you may want to write it like this:

WITH DELETE_CTE AS 
(
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
	layoffs_staging
) duplicates
WHERE 
	row_num > 1
)

delete from delete_cte;

# Delete key can not updat CTE that's why we need to add a column named 'row_num' in a new table.
-- one solution, which I think is a good one. Is to create a new column and add those row numbers in. Then delete where row numbers are over 2, then delete that column
-- so let's do it!

ALTER TABLE layoffs_staging ADD row_num INT;

select * from layoffs_staging;

describe table layoffs_staging;


CREATE TABLE `Layoffs__Staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
row_num INT
);


select * 
from layoffs__staging2;

-- inserting the data of 'layoffs_staging' table and 'row_num' column data by 
-- here we are having duplicate columns so we need to remove one due to some ambiguity  

Alter table layoffs_staging
drop column row_num;

select * from layoffs__staging2;

INSERT INTO layoffs__staging2
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
`row_num`)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		layoffs_staging;

-- now that we have this we can delete rows were row_num is greater than 2

DELETE FROM layoffs__staging2
WHERE row_num >= 2;

select * from layoffs__staging2
where company='oda';
-- Checking whether the data is deleted or not.

select *
from layoffs__staging2
where row_num>1;

# empty so data is deleted 

# remove unessesary tables 
drop table layoffs_staging2;

drop table layoffs_staging_p1;
---------------------------------------------------------------------------

## 2. Standardizing data ## 
-- (finding issues in the data and then fixing it)

-- look at column 'company'
-- Removing a space at the beginning in column 'Company'

select * from layoffs__staging2;

UPDATE layoffs__staging2
SET company = trim(company);



SELECT * 
FROM layoffs__staging2;

-- if we look at industry it looks like we have some null and empty data in the cell, let's take a look at these
-- looking at column 'industry'

SELECT DISTINCT industry
FROM layoffs__staging2
ORDER BY 1;

SELECT *
FROM layoffs__staging2
WHERE industry IS NULL 
OR industry = ''
order by 1;


# "is" operator is mainly used for null value check
 
-- updating 'Crypto Currency' and 'CryptoCurrency' with 'Crypto' in column 'industry'

UPDATE layoffs__staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- Checking whether the data is updated or not.

select distinct industry
from layoffs__staging2
order by 1;

-- looking at column 'country'
# Q) distinct works with one column or we can use more than one 

SELECT DISTINCT country
FROM layoffs__staging2
ORDER BY 1;

-- updating 'United States.' with 'United States'

UPDATE layoffs__staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Checking whether the data is updated or not.

SELECT DISTINCT country
FROM layoffs__staging2
ORDER BY 1;

-- looking at column 'date'
-- here in parameter we have to specify the formate of the data which the function is gone take as input
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
from layoffs__staging2;

-- updating 'date' column and changing its format from text to date.

UPDATE layoffs__staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs__staging2
MODIFY COLUMN `date` DATE;

---------------------------------------------------------------------------

## 3. Handling Null values or Blank values ##


SELECT *
FROM layoffs__staging2
WHERE industry IS NULL
OR industry= ''; 

-- replacing blank values with 'NULL' 

UPDATE layoffs__staging2
SET industry = NULL
WHERE industry = ''; 



-- Try to figure out if any row contains the industry name for the same company in the other rows so that we could replace with that.


SELECT *
FROM layoffs__staging2
WHERE company ='Airbnb';

-- above query output: there are other rows which contain the industry name for the same company that is 'Travel.'

SELECT *
FROM layoffs__staging2
WHERE company ='carvana';

-- above query output: there are other rows which contain the industry name for the same company that is 'Transportation.'

SELECT *
FROM layoffs__staging2
WHERE company ='juul';

-- above query output: there are other rows which contain the industry name for the same company that is 'Consumer.'
SELECT *
FROM layoffs__staging2
WHERE company LIKE 'Bally%';

-- above query output: No other row contains the industry name for the same company


-- here we are doing self join so that we could get to know from the table where the industry name is given for the same company and
-- where the industry name is NULL so that we could replace them with the available values.

SELECT t1.industry,t2.industry
FROM layoffs__staging2 t1
JOIN layoffs__staging2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Replacing the industry column's NULL values with the available values we got from the last query. 

UPDATE layoffs__staging2 t1
JOIN layoffs__staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;


-- Checking whether the data is updated or not.

SELECT *
FROM layoffs__staging2
WHERE industry IS NULL
OR industry= ''; 

-- Note: All the values are updated except ‘Bally’s Interactive’ company as no other row contains the industry name 
-- for the ‘Bally’s Interactive’ company.


-- looking for the rows where 'total_laid_off' and 'percentage_laid_off' column values are NULL

SELECT *
FROM layoffs__staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- deleting all the rows which contains NULL value in 'total_laid_off' and 'percentage_laid_off' column.

DELETE
FROM layoffs__staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Checking whether the data is deleted or not.

SELECT *
FROM layoffs__staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

---------------------------------------------------------------------------

## 4. Remove any columns unneccessary ##

ALTER TABLE layoffs__staging2
DROP COLUMN row_num;




-- ------------ Final_cleaned_data ---------------- --

SELECT *
FROM layoffs__staging2;
-- -----------------------------------------------------
-- Q) company ,location,industry,fds>200

select company,location,industry,funds_raised_millions from layoffs__staging2
where funds_raised_millions>200;
