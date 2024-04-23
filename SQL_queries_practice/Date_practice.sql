SELECT job_posted_date
FROM job_postings_fact 
LIMIT 10;

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM 
    job_postings_fact;

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM 
    job_postings_fact
LIMIT 5;

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM 
    job_postings_fact
LIMIT 5;

-- usage of date extraction 

SELECT 
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month 
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
    month 
ORDER BY
    job_posted_count DESC;

-- find average salary both yearly and hourly for job postings after June 1, 2023
-- group by job schedule type 

SELECT
    job_schedule_type,
    AVG(salary_year_avg) AS avg_salary,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
WHERE
    salary_year_avg is not null AND 
    job_schedule_type is not null AND 
    job_posted_date >= '2023-06-01'
GROUP BY
    job_schedule_type, 
    month

SELECT
    job_schedule_type,
    AVG(salary_hour_avg) AS avg_salary,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
WHERE
    salary_hour_avg is not null AND 
    job_schedule_type is not null AND 
    job_posted_date >= '2023-06-01'
GROUP BY
    job_schedule_type, 
    month

-- count number of job postings per month in 2023
-- adjust timezone to 'America/New York' before extracting the month
-- group by and order by month 

SELECT 
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS month 
FROM 
    job_postings_fact
GROUP BY 
    month 
ORDER BY
    month

-- find companies (include company names) that posted jobs offering health insurance
-- include where these postings where made in the second quarter of 2023
-- use date extraction to filter by quarter 

SELECT 
    companies.name AS company,
    job_postings.job_health_insurance AS health_insurance,
    job_postings.job_via AS location_post,
    EXTRACT(MONTH from job_postings.job_posted_date) AS month
FROM job_postings_fact AS job_postings 
LEFT JOIN company_dim AS companies
    ON job_postings.company_id = companies.company_id
WHERE 
    job_postings.job_posted_date BETWEEN '2023-04-01' AND '2023-06-30'
GROUP BY 
    company,
    health_insurance,
    location_post,
    month
ORDER BY
    month