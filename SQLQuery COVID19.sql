Select *
From [PortfolioProject COVID19 ].dbo.CovidDeaths
order by 3,4


SELECT Location, date, total_cases, new_cases, total_deaths,population
FROM [PortfolioProject COVID19 ].dbo.CovidDeaths
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [PortfolioProject COVID19 ].dbo.CovidDeaths
--WHERE location like '%south%'
ORDER BY 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population had covid

SELECT Location, date, population,total_cases,(total_cases/population)*100 AS PercentagePopulationInfected
FROM [PortfolioProject COVID19 ].dbo.CovidDeaths
--WHERE location like '%south%'
ORDER BY 1,2

--Which countries had the highest infection rates compared to population

SELECT Location, population,MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM [PortfolioProject COVID19 ].dbo.CovidDeaths
--WHERE location like '%south%'
GROUP BY Location, Population
ORDER BY PercentagePopulationInfected desc

--Showing countries with the highest death count per population

SELECT Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [PortfolioProject COVID19 ].dbo.CovidDeaths
--WHERE location like '%south%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc


--Showing the continents with the highest death count per population

SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [PortfolioProject COVID19 ].dbo.CovidDeaths
--WHERE location like '%south%'
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount desc

SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [PortfolioProject COVID19 ].dbo.CovidDeaths
--WHERE location like '%south%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


--Global numbers

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM [PortfolioProject COVID19 ].dbo.CovidDeaths
--WHERE location like '%south%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2


--Let's join the two tables
--Looking at the total population vs vaccinations

SELECT *
FROM [PortfolioProject COVID19 ].dbo.CovidDeaths dea
Join [PortfolioProject COVID19 ].dbo.CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
FROM [PortfolioProject COVID19 ].dbo.CovidDeaths dea
Join [PortfolioProject COVID19 ].dbo.CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


--Creating View to store data for later visualizations

CREATE VIEW 

