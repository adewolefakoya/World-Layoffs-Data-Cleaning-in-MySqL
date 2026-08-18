   --- Data Cleaning 
   
select *
from layoffs;

create table layoffs_staging
like layoffs;

select *
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;

select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

with duplicate_cte as 
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;


with duplicate_cte as 
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) as row_num
from layoffs_staging
)
Delete
from duplicate_cte
where row_num > 1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2
select *,
row_number() over(
partition by company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) as row_num
from layoffs_staging;

delete
from layoffs_staging2
WHERE row_num > 1;

select *
from layoffs_staging2;


select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

SELECT distinct industry
from layoffs_staging2
;

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%' ;

update layoffs_staging2
set company = trim(company);


select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';


select `date` 
from layoffs_staging2;


update layoffs_staging2
set `date` = str_to_date( `date`, '%m/%d/%Y');


alter table layoffs_staging2
modify column `date` DATE;

SELECT *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


SELECT *
from layoffs_staging2
where industry is null
or industry = '';


SELECT *
from layoffs_staging2
where company = 'Airbnb';


select *
from layoffs_staging2 t1
join layoffs_staging2 t2
   on t1.company = t2.company
   and t1.location = t2.location
   where (t1.industry is null or t1.industry = '')
   and t2.industry is not null;
   
   update layoffs_staging2
   set industry = null
   where industry = '';
   
   update layoffs_staging2 t1
   join layoffs_staging2 t2
   on t1.company = t2.company
   set t1.industry = t2.industry
   where t1.industry is null 
   and t2.industry is not null;
   
   select *
   from layoffs_staging2
   where company = 'airbnb';
   
   select *
   from layoffs_staging2
   where total_laid_off is null
   and percentage_laid_off is null;
   
   delete
   from layoffs_staging2
   where total_laid_off is null
   and percentage_laid_off is null;
   
   select *
   from layoffs_staging2; 
   
   
   ALTER table layoffs_staging2
   drop column row_num;

  -- Exploratory Data Analysis
  
  select *
   from layoffs_staging2;
   
   select max(total_laid_off), max(percentage_laid_off)
   from layoffs_staging2; 
  
  select *
   from layoffs_staging2
   where percentage_laid_off = 1
   order by total_laid_off desc;
   
   select company, sum(total_laid_off)
   from layoffs_staging2
   group by company
   order by 2 desc;
   
   select min(`date`), max(`date`)
   from layoffs_staging2;
   
     select country, sum(total_laid_off)
   from layoffs_staging2
   group by country
   order by 2 desc;
   
    select company, sum(total_laid_off)
   from layoffs_staging2
   group by company
   order by 2 desc;
   
    select company, YEAR(`date`), sum(total_laid_off)
   from layoffs_staging2
   group by company, YEAR(`date`)
   order by 3 desc;
   
   
   with company_year (company, years, total_laid_off) as
   (
    select company, YEAR(`date`), sum(total_laid_off)
   from layoffs_staging2
   group by company, YEAR(`date`)
   ), company_year_rank as
   (select *, 
   dense_rank() over (partition by years order by total_laid_off desc) as ranking
   from company_year
   where years is not null)
   select *
   from company_year_rank
   where ranking <= 5
   ;
   
   
   
   
   select year(`date`), sum(total_laid_off)
   from layoffs_staging2
   group by year(`date`)
   order by 1 desc;
   
   select stage, sum(total_laid_off)
   from layoffs_staging2
   group by stage
   order by 2 desc;
   
    select substring(`date` ,1,7) as `MONTH`, sum(total_laid_off)
   from layoffs_staging2
   where substring(`date` ,1,7) is not null
   group by `MONTH`
   ORDER BY 1 ASC;
   
 WITH Rolling_Total as 
 (
 select substring(`date` ,1,7) as `MONTH`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date` ,1,7) is not null
group by `MONTH`
ORDER BY 1 ASC
)
select `MONTH`, total_off 
, sum(total_off) over(order by `MONTH`) as rolling_total
from Rolling_Total;
   