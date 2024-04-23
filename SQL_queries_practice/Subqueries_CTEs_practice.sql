-- Subqueries 

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;

-- CTEs 

WITH january_jobs AS ( 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT * 
FROM january_jobs

-- Practice subqueries 

SELECT 
    company_id,
    name AS company_name 
FROM 
    company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM 
        job_postings_fact
    WHERE 
        job_no_degree_mention = true
    ORDER BY
        company_id
)

-- Practice CTEs
/*
Find companies with the most job openings.
- Get total number of job postings per company id
- Return total number of jobs with the company name 
*/

-- this gives total number of job postings per company id; will be used in CTE 
SELECT 
    company_id,
    COUNT(*)
FROM 
    job_postings_fact
GROUP BY
    company_id

-- CTE & LEFT JOIN to combine company_name and company_id
WITH company_job_count AS (
   SELECT 
        company_id,
        COUNT(*) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY
        company_id 
)

SELECT 
    company_dim.name AS company_name, 
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count 
    ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC;

-- Practice Problem 1
/*
Identify top 5 skills most frequently mentioned in job postings.
- Use subquery to find skill IDs with the highest count in skills_job_dim
- Join this result with skills_dim to get skill names 
*/

SELECT *
FROM skills_dim

SELECT
    skills,
FROM skills_dim
WHERE skill_id IN (
    SELECT 
        COUNT(*) AS skill_count
    FROM skills_job_dim AS skills_to_job
    GROUP BY
        skill_id
    ORDER BY
        skill_count
)
LIMIT 5;

-- Practice Problem 2 
/*
Determine size category for each company
- Identify number of job postings per company (use subquery)
- Size categories: "Small" (<10), "Medium" (10-50), "Large" (>50)
*/


SELECT
    company_dim.name,
    COUNT(job_postings_fact.job_id) AS count_job_postings,
    CASE
            WHEN COUNT(job_postings_fact.company_id) <10 THEN 'Small'
            WHEN COUNT(job_postings_fact.company_id) BETWEEN 10 AND 50 THEN 'Medium'
            ELSE 'Large'
    END AS category_job_postings
FROM job_postings_fact
LEFT JOIN company_dim
    ON company_dim.company_id = job_postings_fact.company_id
GROUP BY
    company_dim.name
ORDER BY
    count_job_postings DESC;


-- Practice Problem 7 (video)
/*
Find the count of the number of remote job postings per skill
- Display the top 5 skills by their demand in remote jobs
- Include skill ID, name, and count of postings requiring the skill
*/

WITH remote_job_skills AS (
    SELECT 
        skill_id,
        COUNT(*) AS skill_count
    FROM 
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings
        ON job_postings.job_id = skills_to_job.job_id
    WHERE 
        job_postings.job_work_from_home = true AND 
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT 
    skill.skill_id,
    skills as skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skill
    ON skill.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;
