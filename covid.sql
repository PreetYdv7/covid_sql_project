-- Covid 19 Data Exploration
-- Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
-- Select Data that we are going to be using
SELECT location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM covid_deaths
ORDER BY location,
    date;
-- Looking at Total Cases vs Total Deaths Globally
SELECT location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location,
    date;
-- Looking at Total Cases vs Total Deaths in United States
SELECT location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM covid_deaths
WHERE location = 'United States'
ORDER BY date;
-- Looking at Total Cases vs Population
-- Shows what percentage of US population got Covid
SELECT location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 AS CovidPercentage
FROM covid_deaths
WHERE location = 'United States'
ORDER BY date;
-- Looking at Countries with Highest Infection Rate compared to Population
SELECT location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM covid_deaths
GROUP BY location,
    population
ORDER BY PercentPopulationInfected DESC;
-- Showing Countries with Highest Death Count
SELECT location,
    MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;
-- Showing Death Count by Continent
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
-- Global Numbers
-- Total Cases, Death, and Death Percentage by Date
SELECT date,
    SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;
-- Total Cases, Deaths and Death Percentage Overall
SELECT SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL;
-- Looking at Total Population vs Vaccinations
-- Shows Percentage of Population that has received at least one Covid Vaccine
SELECT dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INT)) OVER (
        PARTITION BY dea.location
        ORDER BY dea.location,
            dea.date
    ) AS RollingPeopleVaccinated
FROM covid_deaths AS dea
    JOIN covid_vaccinations AS vac ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY location,
    date;
-- Using CTE to Calculate Total Vaccination Percentage By Date
WITH PopvsVac (
    Continent,
    Location,
    Date,
    Population,
    New_Vaccinations,
    RollingPeopleVaccinated
) AS (
    SELECT dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS INT)) OVER (
            PARTITION BY dea.location
            ORDER BY dea.location,
                dea.date
        ) AS RollingPeopleVaccinated
    FROM covid_deaths AS dea
        JOIN covid_vaccinations AS vac ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *,
    (RollingPeopleVaccinated / Population) * 100 AS VaccinationPercentage
FROM PopvsVac;
-- Creating a Temp Table To Perform Same Calculation as Above
DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMP TABLE PercentPopulationVaccinated (
    Continent TEXT,
    Location TEXT,
    Date DATE,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);
INSERT INTO PercentPopulationVaccinated
SELECT dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INT)) OVER (
        PARTITION BY dea.location
        ORDER BY dea.location,
            dea.date
    ) AS RollingPeopleVaccinated
FROM covid_deaths AS dea
    JOIN covid_vaccinations AS vac ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
SELECT *,
    (RollingPeopleVaccinated / Population) * 100 AS VaccinationPercentage
FROM PercentPopulationVaccinated;
-- Creating View to store data for later visualizations
CREATE OR REPLACE VIEW PercentPopulationVaccinated AS WITH PopvsVac (
        Continent,
        Location,
        Date,
        Population,
        New_Vaccinations,
        RollingPeopleVaccinated
    ) AS (
        SELECT dea.continent,
            dea.location,
            dea.date,
            dea.population,
            vac.new_vaccinations,
            SUM(CAST(vac.new_vaccinations AS INT)) OVER (
                PARTITION BY dea.location
                ORDER BY dea.location,
                    dea.date
            ) AS RollingPeopleVaccinated
        FROM covid_deaths AS dea
            JOIN covid_vaccinations AS vac ON dea.location = vac.location
            AND dea.date = vac.date
        WHERE dea.continent IS NOT NULL
    )
SELECT *,
    (RollingPeopleVaccinated / Population) * 100 AS VaccinationPercentage
FROM PopvsVac;
-- Finding the Total Vaccination Percentage of Each Country Using View Created Above
SELECT location,
    MAX(VaccinationPercentage) AS TotalVacPercentage
FROM PercentPopulationVaccinated
GROUP BY location
ORDER BY TotalVacPercentage DESC;