-- 5. Countries with Highest Death Count
SELECT
    location,
    MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY
    location
ORDER BY
    TotalDeathCount DESC;