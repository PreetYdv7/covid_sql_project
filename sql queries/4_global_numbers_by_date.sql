-- 4. Global Totals
SELECT
    SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM
    covid_deaths
WHERE
    continent IS NOT NULL;