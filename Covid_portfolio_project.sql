SELECT *
FROM PortfolioProject. .covideath
WHERE continent IS NOT NULL
order by 3 ,4


--SELECT *
--FROM PortfolioProject. .covidvaccinations
--order by 3 ,4


--SELECT DATA THET WE ARE GOÝNG TO USÝNG

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject. .covideath
WHERE continent IS NOT NULL
order by 1,2

-- Looking at total cases vs total deaths

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProject..covideath
Where location like '%turkey%'
order by 1,2


--looking total cases vs population
--Show what percentage got Covid

Select location, date, total_cases,population, 
(CONVERT(float, population) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProject..covideath
Where location like '%turkey%'
order by 1,2

-- Looking at Countries with Highest Infection compared to Population

Select 
location, 
population, 
MAX(total_cases) as HýghestInfectionCount,
MAX(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
FROM PortfolioProject . . covideath
WHERE continent IS NOT NULL
GROUP BY location, population
--Where location like '%turkey%'
order by PercentPopulationInfected desc



--Showing the Countries with Highest Death Count per Population

SELECT 
location,
MAX(CAST(COALESCE(total_deaths, '0') as float)) AS TotalDeathCount
FROM PortfolioProject..covideath
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


--BY CONTÝNENT
SELECT 
continent,
MAX(CAST(COALESCE(total_deaths, '0') as float)) AS TotalDeathCount
FROM PortfolioProject..covideath
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


--GLOBAL NUMBERS

SELECT date, MAX(total_cases) as Total_cases, 
MAX(CAST(COALESCE(total_deaths, '0') as float)) as Total_deaths,
 MAX(CAST(COALESCE(total_deaths, '0') as float))/MAX(total_cases) *100 as DeathPercentage
FROM PortfolioProject .. covideath
WHERE continent is not null
GROUP BY date
ORDER BY 1,2 

--LOOKÝNG AT TOTAL POPULATÝON vs VACCÝNATÝONS



SELECT
 dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM
    PortfolioProject .. covideath dea
INNER JOIN
    PortfolioProject .. covidvaccinations vac
ON
    dea.location = vac.location AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
ORDER BY
    1,2




-- USE CTE

With PopvsVac (Continent , Location , Date , Population, New_vaccinations, RollingPeopleVaccinated)
as
(SELECT
 dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM
    PortfolioProject .. covideath dea
INNER JOIN
    PortfolioProject .. covidvaccinations vac
ON
    dea.location = vac.location AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
)

SELECT *,(RollingPeopleVaccinated/ Population)*100
FROM PopvsVac



-- TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)



Insert into #PercentPopulationVaccinated
SELECT
 dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM
    PortfolioProject .. covideath dea
INNER JOIN
    PortfolioProject .. covidvaccinations vac
ON
    dea.location = vac.location AND dea.date = vac.date
----WHERE
--    dea.continent IS NOT NULL


SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated




--CREATÝNG VÝEW


Create View  
DeathPercentageofTurkey as
Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProject..covideath
Where location like '%turkey%'
--order by 1,2





-- Looking at Countries with Highest Infection compared to Population


CREATE View
CountriesWithHighestInfection as
Select 
location, 
population, 
MAX(total_cases) as HýghestInfectionCount,
MAX(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
FROM PortfolioProject . . covideath
WHERE continent IS NOT NULL
GROUP BY location, population
--Where location like '%turkey%'
--order by PercentPopulationInfected desc



--PercentPopulationVaccinated


CREATE View 
PercentPopulationVaccinated as
SELECT
 dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM
    PortfolioProject .. covideath dea
INNER JOIN
    PortfolioProject .. covidvaccinations vac
ON
    dea.location = vac.location AND dea.date = vac.date
----WHERE
--    dea.continent IS NOT NULL


--GLOBAL NUMBERS
Create View 
GlobalNumbers as
SELECT date, MAX(total_cases) as Total_cases, 
MAX(CAST(COALESCE(total_deaths, '0') as float)) as Total_deaths,
 MAX(CAST(COALESCE(total_deaths, '0') as float))/MAX(total_cases) *100 as DeathPercentage
FROM PortfolioProject .. covideath
WHERE continent is not null
GROUP BY date
--ORDER BY 1,2 


