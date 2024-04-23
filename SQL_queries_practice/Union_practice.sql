SELECT
    job_title_short, 
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

SELECT
    job_title_short, 
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

SELECT
    job_title_short, 
    company_id,
    job_location
FROM
    march_jobs

-- Practice Problem 1 
-- get corresponding skill and skill type for each job posting in q1
-- includes those without any skills too
-- why? look at the skills and type for each job in the first quarter that has a salary > 70000

WITH q1_job_postings AS (
    SELECT 
        quarter1_job_postings.job_title_short,
        quarter1_job_postings.job_location,
        quarter1_job_postings.job_via,
        quarter1_job_postings.job_posted_date::DATE,
        quarter1_job_postings.salary_year_avg,
        skills_job_dim.skill_id
    FROM (
        SELECT *
        FROM january_jobs
        UNION ALL 
        SELECT *
        FROM february_jobs
        UNION ALL
        SELECT *
        FROM march_jobs
    ) AS quarter1_job_postings
    INNER JOIN skills_job_dim
        ON quarter1_job_postings.job_id = skills_job_dim.job_id
)

SELECT 
    q1_job_postings.job_title_short,
    q1_job_postings.job_location,
    q1_job_postings.job_via,
    q1_job_postings.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM q1_job_postings
INNER JOIN skills_dim 
    ON q1_job_postings.skill_id = skills_dim.skill_id
WHERE 
    salary_year_avg > 70000 AND 
    salary_year_avg is not null AND 
    job_title_short = 'Data Analyst'
ORDER BY
    q1_job_postings.salary_year_avg DESC;


-- Practice Problem 8 (video)
/*
Find job postings from the first quarter that have a salary greater than 70k
- Combine job posting tables from the first quarter of 2023 (Jan-Mar)
- Gets job postings with an average yearly salary > 70k
*/

SELECT 
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL 
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
WHERE
    salary_year_avg > 70000 AND 
    job_title_short = 'Data Analyst'
ORDER BY 
    salary_year_avg DESC;