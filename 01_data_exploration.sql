-- Query 1: Preview the data
SELECT *
FROM job_postings_fact
LIMIT 5;

-- Query 2: See the table structure
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'job_postings_fact'
ORDER BY ordinal_position;

-- Query 3: Total number of job postings
SELECT COUNT(*) AS total_job_postings
FROM job_postings_fact;

-- Query 4: Check missing values in important columns
SELECT
    COUNT(*) AS total_jobs,
    COUNT(job_title_short) AS jobs_with_title,
    COUNT(job_location) AS jobs_with_location,
    COUNT(salary_year_avg) AS jobs_with_salary,
    COUNT(company_id) AS jobs_with_company,
    COUNT(job_posted_date) AS jobs_with_posted_date
FROM job_postings_fact;

-- Query 5: Most common job titles
SELECT
    job_title_short,
    COUNT(*) AS job_count
FROM job_postings_fact
GROUP BY job_title_short
ORDER BY job_count DESC;

-- Query 6: Total Data Analyst job postings
SELECT
    COUNT(*) AS data_analyst_jobs
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst';

-- Query 7: Top locations for Data Analyst jobs
SELECT
    job_location,
    COUNT(*) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY job_location
ORDER BY job_count DESC
LIMIT 20;

-- Query 8: Remote vs non-remote Data Analyst jobs
SELECT
    job_work_from_home,
    COUNT(*) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY job_work_from_home
ORDER BY job_count DESC;

-- Query 9: Data Analyst salary overview
SELECT
    COUNT(salary_year_avg) AS jobs_with_salary,
    ROUND(MIN(salary_year_avg), 2) AS minimum_salary,
    ROUND(MAX(salary_year_avg), 2) AS maximum_salary,
    ROUND(AVG(salary_year_avg), 2) AS average_salary
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
  AND salary_year_avg IS NOT NULL;

-- Query 10: Average Data Analyst salary by location
SELECT
    job_location,
    COUNT(*) AS job_count,
    ROUND(AVG(salary_year_avg), 2) AS average_salary
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
  AND salary_year_avg IS NOT NULL
GROUP BY job_location
ORDER BY average_salary DESC
LIMIT 20;

-- Query 12: Companies with the most Data Analyst job postings
SELECT
    c.name AS company_name,
    COUNT(*) AS job_count
FROM job_postings_fact AS j
INNER JOIN company_dim AS c
    ON j.company_id = c.company_id
WHERE j.job_title_short = 'Data Analyst'
GROUP BY c.name
ORDER BY job_count DESC
LIMIT 20;

-- Query 13: Preview skills
SELECT *
FROM skills_dim
LIMIT 10;

-- Query 14: Preview job-skill relationships
SELECT *
FROM skills_job_dim
LIMIT 10;

-- Query 15: Most demanded skills for Data Analyst jobs
SELECT
    s.skills,
    COUNT(*) AS demand_count
FROM job_postings_fact AS j
INNER JOIN skills_job_dim AS sj
    ON j.job_id = sj.job_id
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
WHERE j.job_title_short = 'Data Analyst'
GROUP BY s.skills
ORDER BY demand_count DESC
LIMIT 20;

-- Query 16: Skill demand as a percentage of Data Analyst jobs
SELECT
    s.skills,
    COUNT(*) AS demand_count,
    ROUND(
        COUNT(*) * 100.0 /
        (
            SELECT COUNT(*)
            FROM job_postings_fact
            WHERE job_title_short = 'Data Analyst'
        ),
        2
    ) AS demand_percentage
FROM job_postings_fact AS j
INNER JOIN skills_job_dim AS sj
    ON j.job_id = sj.job_id
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
WHERE j.job_title_short = 'Data Analyst'
GROUP BY s.skills
ORDER BY demand_percentage DESC
LIMIT 20;

-- Query 17: Average salary associated with each skill
SELECT
    s.skills,
    COUNT(*) AS job_count,
    ROUND(AVG(j.salary_year_avg), 2) AS average_salary
FROM job_postings_fact AS j
INNER JOIN skills_job_dim AS sj
    ON j.job_id = sj.job_id
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
WHERE j.job_title_short = 'Data Analyst'
  AND j.salary_year_avg IS NOT NULL
GROUP BY s.skills
ORDER BY average_salary DESC
LIMIT 20;

-- Query 18: Skills with sufficient salary observations
SELECT
    s.skills,
    COUNT(*) AS job_count,
    ROUND(AVG(j.salary_year_avg), 2) AS average_salary
FROM job_postings_fact AS j
INNER JOIN skills_job_dim AS sj
    ON j.job_id = sj.job_id
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
WHERE j.job_title_short = 'Data Analyst'
  AND j.salary_year_avg IS NOT NULL
GROUP BY s.skills
HAVING COUNT(*) >= 50
ORDER BY average_salary DESC;

-- Query 19: Skill salary analysis using a CTE
WITH skill_salary AS (
    SELECT
        s.skills,
        COUNT(*) AS job_count,
        AVG(j.salary_year_avg) AS average_salary
    FROM job_postings_fact AS j
    INNER JOIN skills_job_dim AS sj
        ON j.job_id = sj.job_id
    INNER JOIN skills_dim AS s
        ON sj.skill_id = s.skill_id
    WHERE j.job_title_short = 'Data Analyst'
      AND j.salary_year_avg IS NOT NULL
    GROUP BY s.skills
)

SELECT
    skills,
    job_count,
    ROUND(average_salary, 2) AS average_salary
FROM skill_salary
WHERE job_count >= 50
ORDER BY average_salary DESC;

-- Query 20: Rank skills by average salary
WITH skill_salary AS (
    SELECT
        s.skills,
        COUNT(*) AS job_count,
        AVG(j.salary_year_avg) AS average_salary
    FROM job_postings_fact AS j
    INNER JOIN skills_job_dim AS sj
        ON j.job_id = sj.job_id
    INNER JOIN skills_dim AS s
        ON sj.skill_id = s.skill_id
    WHERE j.job_title_short = 'Data Analyst'
      AND j.salary_year_avg IS NOT NULL
    GROUP BY s.skills
    HAVING COUNT(*) >= 50
)

SELECT
    skills,
    job_count,
    ROUND(average_salary, 2) AS average_salary,
    RANK() OVER (
        ORDER BY average_salary DESC
    ) AS salary_rank
FROM skill_salary
ORDER BY salary_rank;

-- Query 21: Rank skills by demand
WITH skill_demand AS (
    SELECT
        s.skills,
        COUNT(*) AS demand_count
    FROM job_postings_fact AS j
    INNER JOIN skills_job_dim AS sj
        ON j.job_id = sj.job_id
    INNER JOIN skills_dim AS s
        ON sj.skill_id = s.skill_id
    WHERE j.job_title_short = 'Data Analyst'
    GROUP BY s.skills
)

SELECT
    skills,
    demand_count,
    RANK() OVER (
        ORDER BY demand_count DESC
    ) AS demand_rank
FROM skill_demand
ORDER BY demand_rank;

-- Query 22: Combined skill demand and salary analysis
WITH skill_analysis AS (
    SELECT
        s.skills,
        COUNT(*) AS demand_count,
        AVG(j.salary_year_avg) AS average_salary
    FROM job_postings_fact AS j
    INNER JOIN skills_job_dim AS sj
        ON j.job_id = sj.job_id
    INNER JOIN skills_dim AS s
        ON sj.skill_id = s.skill_id
    WHERE j.job_title_short = 'Data Analyst'
      AND j.salary_year_avg IS NOT NULL
    GROUP BY s.skills
    HAVING COUNT(*) >= 50
)

SELECT
    skills,
    demand_count,
    ROUND(average_salary, 2) AS average_salary,

    RANK() OVER (
        ORDER BY demand_count DESC
    ) AS demand_rank,

    RANK() OVER (
        ORDER BY average_salary DESC
    ) AS salary_rank

FROM skill_analysis
ORDER BY demand_rank;

-- Query 23: Top 10 most demanded Data Analyst skills
WITH skill_demand AS (
    SELECT
        s.skills,
        COUNT(*) AS demand_count
    FROM job_postings_fact AS j
    INNER JOIN skills_job_dim AS sj
        ON j.job_id = sj.job_id
    INNER JOIN skills_dim AS s
        ON sj.skill_id = s.skill_id
    WHERE j.job_title_short = 'Data Analyst'
    GROUP BY s.skills
)

SELECT
    skills,
    demand_count,
    RANK() OVER (
        ORDER BY demand_count DESC
    ) AS demand_rank
FROM skill_demand
ORDER BY demand_rank
LIMIT 10;

-- Query 24: Top 10 skills by average salary
WITH skill_salary AS (
    SELECT
        s.skills,
        COUNT(*) AS job_count,
        AVG(j.salary_year_avg) AS average_salary
    FROM job_postings_fact AS j
    INNER JOIN skills_job_dim AS sj
        ON j.job_id = sj.job_id
    INNER JOIN skills_dim AS s
        ON sj.skill_id = s.skill_id
    WHERE j.job_title_short = 'Data Analyst'
      AND j.salary_year_avg IS NOT NULL
    GROUP BY s.skills
    HAVING COUNT(*) >= 50
)

SELECT
    skills,
    job_count,
    ROUND(average_salary, 2) AS average_salary,
    RANK() OVER (
        ORDER BY average_salary DESC
    ) AS salary_rank
FROM skill_salary
ORDER BY salary_rank
LIMIT 10;

-- Query 25: Final high-value skill analysis
WITH skill_analysis AS (
    SELECT
        s.skills,
        COUNT(*) AS demand_count,
        AVG(j.salary_year_avg) AS average_salary
    FROM job_postings_fact AS j
    INNER JOIN skills_job_dim AS sj
        ON j.job_id = sj.job_id
    INNER JOIN skills_dim AS s
        ON sj.skill_id = s.skill_id
    WHERE j.job_title_short = 'Data Analyst'
      AND j.salary_year_avg IS NOT NULL
    GROUP BY s.skills
    HAVING COUNT(*) >= 50
)

SELECT
    skills,
    demand_count,
    ROUND(average_salary, 2) AS average_salary,

    RANK() OVER (
        ORDER BY demand_count DESC
    ) AS demand_rank,

    RANK() OVER (
        ORDER BY average_salary DESC
    ) AS salary_rank

FROM skill_analysis
ORDER BY demand_rank;