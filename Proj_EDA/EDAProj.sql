# EDA (Explotary Data Analysis)

--  This project utilizes SQL to analyze data on employee layoffs within a company. 
-- Here we are going to explore the data and find trends or patterns or anything intresting like outliers. 
-- One will gain experience in:
-- •	Identifying trends and patterns in workforce data.
-- •	Communicating data-driven insights and recommendations.

-- ============================================================================================================

-- This query retrieves the data of a table.
select * from  layoffs__staging2;


/*This query helps you to find the peak instance of employee layoffs within the timeframe covered by the data.
This can indicate the most severe(the great) period of workforce reduction.*/

select max(total_laid_off) from layoffs__staging2;

-- i need company name which had maximum layoff during certian time period 

select company ,max(total_laid_off) from layoffs__staging2
group by company
order by max(total_laid_off) desc
limit 1;


/*This query provides you to find the highest number of employees laid off within a dataset 
when the percentage of employee layoffs is 100%*/


# this mean the company which had made 100 % laid off ,what may  the number of employee had been worked for company 
select max(total_laid_off) from layoffs__staging2
where percentage_laid_off=1; # this mean 100% laid off



-- Looking at Percentage to see how big these layoffs were

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs__staging2;

/*This query provides you to find the specific layoffs 
where 1 (representing 100%) of employees were laid off from a company 
where the entire workforce was laid off.*/


Select *
from layoffs__staging2
where percentage_laid_off =1
order by total_laid_off desc;

/*This query provides you to find the total number of employees laid off at each company and 
shows which companies experienced the most overall layoffs.*/

select company,sum(total_laid_off) from layoffs__staging2
group by company 
order by 2 desc;

-- This query provides you to find the date range of employee layoffs in the given data.

Select min(`date`), max(`date`)
from layoffs__staging2;

/*This query provides you to find the total number of employees laid off within each industry sector and 
shows which industries experienced the most overall layoffs.*/

select industry,sum(total_laid_off) from layoffs__staging2
where industry is not null
group by industry
order by industry desc;

-- the execution flow is:

/* Table access -> Row filtering -> Grouping -> Aggregation -> Column selection -> Result sorting.

-- ascending order by if we hv then the null will be the first row in the result table 

/*This query provides you to find the total number of employees laid off within each country and 
shows which countries experienced the most overall layoffs.*/

select country,sum(total_laid_off) total_layoffs from layoffs__staging2
group by country
having sum(total_laid_off) is not null
order by 2 desc;

/*This query groups layoffs by the year they occurred and 
calculates the total number of employees laid off for each year.*/

-- NOTE : use "`" (back stick) when we are using reserved keyword as column name 
select * from layoffs__staging2;


-- we can use any one of them substring() or year() or left()
select substring(`date`,1,4) from layoffs__staging2;

select year(`date`) from layoffs__staging2;

select left(`date`,4) from layoffs__staging2;

-- query for the above problem 

select year(`date`) as year ,sum(total_laid_off) from layoffs__staging2 as ls2
where date is not null
group by year
order by 1;

-- The given SQL query provides insights into layoff trends monthly within your dataset.



select substring(`date`, 1, 7) as `month`, sum(total_laid_off)
from layoffs__staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc;


/*This query shows the accumulation of layoffs over time.
Rolling Total of Layoffs Per Month with CTE*/


with Rolling_Total as
(
select substring(`date`, 1, 7) as `month`, sum(total_laid_off) as total_off
from layoffs__staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off, sum(total_off) over(order by `month`) as rolling_total
from Rolling_Total;


-- This query shows which companies had the most layoffs in a particular year .


Select Company, year(`date`), sum(total_laid_off)
from layoffs__staging2
group by company, year(`date`)
order by 3 desc;

-- This query identifies the companies with the top 5 highest layoff totals within each year.

WITH CompanyLayoffRank AS (
    SELECT
        Company,
        YEAR(date) AS layoff_year,
        SUM(total_laid_off) AS total_laid_off_yearly,
        ROW_NUMBER() OVER (PARTITION BY YEAR(date) ORDER BY SUM(total_laid_off) DESC) AS rn
    FROM
        layoffs__staging2
    WHERE
        total_laid_off IS NOT NULL -- Exclude rows where total_laid_off is null
        AND date IS NOT NULL        -- Ensure date is not null for year extraction
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
    












