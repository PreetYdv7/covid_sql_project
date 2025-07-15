-- 2. Total Cases vs Total Deaths in United States
SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM
    covid_deaths
WHERE
    location = 'United States'
ORDER BY
    date;