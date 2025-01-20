## Exploratory Data analysis

 
select * from layoffs_staging3;
select max(total_laid_off),max(percentage_laid_off) 
from layoffs_staging3;

select *
from layoffs_staging3
where percentage_laid_off=1;

select *
from layoffs_staging3
where percentage_laid_off=1
order by total_laid_off desc;

select *
from layoffs_staging3
where percentage_laid_off=1
order by funds_raised_millions desc;

select company,sum(total_laid_off)
from layoffs_staging3
group by company
order by 2 desc;

select min(date),max(date)
from layoffs_staging3;

select industry,sum(total_laid_off)
from layoffs_staging3
group by industry
order by 2 desc;

select year(date),sum(total_laid_off)
from layoffs_staging3
group by year(date)
order by 1 desc;

select stage,sum(total_laid_off)
from layoffs_staging3
group by stage
order by 1 desc;

select company,sum(percentage_laid_off)
from layoffs_staging3
group by company
order by 1 desc;

select company,avg(percentage_laid_off)
from layoffs_staging3
group by company
order by 1 desc;

select substring(date,1,7) as Month,sum(total_laid_off)
from layoffs_staging3
where substring(date,1,7) is not null
group by Month
order by 1 asc;

with Rolling_Total as 
(select substring(date,1,7) as 'Month',sum(total_laid_off)as total_off
from layoffs_staging3
where substring(date,1,7) is not null
group by 'Month'
order by 1 asc)
select 'Month',total_off,sum(Total_off) over(order by 'Month')as rolling_total;

select company,year(date),sum(total_laid_off)
from layoffs_staging3
group by company, year(date)
order by company asc;

select company,year(date),sum(total_laid_off)
from layoffs_staging3
group by company, year(date)
order by 3 desc;

with Company_Year(Company,Year,total_laid_off) as
(select company,year(date),sum(total_laid_off)
from layoffs_staging3
group by company, year(date)),company_year_rank as
(select *,dense_rank()over(partition by year order by total_laid_off desc)  as Ranking
from Company_Year
where year is not null) 
select * from company_year_rank
where Ranking <=5;


