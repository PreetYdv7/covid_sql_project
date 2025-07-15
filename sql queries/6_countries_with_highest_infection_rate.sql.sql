-- 6. Countries with Highest Infection Rate (vs Population)
SELECT
    location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
    covid_deaths
GROUP BY
    location,
    population
ORDER BY
    PercentPopulationInfected DESC;