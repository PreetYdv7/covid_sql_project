-- 1. Total Cases vs Total Deaths Globally
SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
ORDER BY
    location,
    date;