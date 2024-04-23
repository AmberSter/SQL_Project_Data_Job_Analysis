SELECT
    job_title_short,
    job_location
FROM 
    job_postings_fact;

/*

Label new column as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'
*/

SELECT
    job_title_short,
    job_location,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact;

-- Analyze how many jobs I can apply to 

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    location_category

-- Practice problem: categorize salaries from each job posting

SELECT
    AVG(salary_year_avg) AS salary,
    CASE 
        WHEN salary_year_avg < 45000 THEN 'Low Salary'
        WHEN salary_year_avg BETWEEN 45000 AND 60000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS salary_category
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    salary_category
ORDER BY
    salary DESC;
