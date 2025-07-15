-- 3. Death Count by Continent
SELECT
    continent,
    SUM(TotalDeathCount) AS TotalDeathCount
FROM
    (
        SELECT
            continent,
            location,
            MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
        FROM
            covid_deaths
        WHERE
            continent IS NOT NULL
        GROUP BY
            continent,
            location
    ) AS deathcountbycountry
GROUP BY
    continent
ORDER BY
    TotalDeathCount DESC;