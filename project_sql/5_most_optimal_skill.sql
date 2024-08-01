/*
Question: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Software Engineer roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis

-Combining CTEs to find out the most optimal skills
-removing order inside cte speeds up query
*/

WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id -- joins the job id's together 
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id -- allows us to access skill name and type
    WHERE 
        job_title_short = 'Software Engineer' 
        AND job_work_from_home = True
        AND salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
    ), 
    
average_salary AS ( -- separate CTEs with a comma using the same with command for both
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary -- 0 indicates how many decimal places we round to 
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id -- joins the job id's together 
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id -- allows us to access skill name and type
    WHERE 
        job_title_short = 'Software Engineer' 
        AND job_work_from_home = True
        AND salary_year_avg IS NOT NULL
    GROUP BY 
        skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY 
    demand_count DESC,
    avg_salary DESC
LIMIT 25;