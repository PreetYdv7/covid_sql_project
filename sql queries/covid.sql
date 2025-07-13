-- Covid 19 Data Exploration (Cleaned for Actual Columns)
-- Skills used: Joins, CTEs, Windows Functions, Aggregates
-- 1. Select basic data
SELECT location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM covid_deaths
ORDER BY location,
    date;
-- 2. Total Cases vs Total Deaths Globally
SELECT location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location,
    date;
-- 3. Total Cases vs Total Deaths in United States
SELECT location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM covid_deaths
WHERE location = 'United States'
ORDER BY date;
-- 4. Total Cases vs Population (U.S.)
SELECT location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 AS CovidPercentage
FROM covid_deaths
WHERE location = 'India'
ORDER BY date;
-- 5. Countries with Highest Infection Rate (vs Population)
SELECT location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM covid_deaths
GROUP BY location,
    population
ORDER BY PercentPopulationInfected DESC;
-- 6. Countries with Highest Death Count
SELECT location,
    MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;
-- 7. Death Count by Continent
SELECT continent,
    SUM(TotalDeathCount) AS TotalDeathCount
FROM (
        SELECT continent,
            location,
            MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
        FROM covid_deaths
        WHERE continent IS NOT NULL
        GROUP BY continent,
            location
    ) AS deathcountbycountry
GROUP BY continent
ORDER BY TotalDeathCount DESC;
-- 8. Global Numbers by Date
SELECT date,
    SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;
-- 9. Global Totals
SELECT SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL;