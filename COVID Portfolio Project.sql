Select *
From [PortfolioProject ]..CovidDeaths$
WHERE continent is not null
order by 3,4

--Select *
--From [PortfolioProject ]..CovidVaccinations$
--order by 3,4

-- Select data we are going to be using 

Select Location, date, total_cases, new_cases, total_deaths, population_density
From [PortfolioProject ]..CovidDeaths$
Where continent is not null
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows the likelihhod of dying if you contract covid in your country 
Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from [PortfolioProject ]..CovidDeaths$ 
Where location like '%states%' 
and continent is not null 
order by 1,2       


-- Looking at the Total Cases vs the Population 
-- Shows what percentage of population got Covid 

Select location, date, population_density, total_cases,  
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS PercentofPopulationInfected 
from [PortfolioProject ]..CovidDeaths$ 
--Where location like '%states%'  
order by 1,2



-- Looking at Countries with Highest Infection Rtae Compared to Population 

Select Location, population_density, MAX(total_cases) as HighestnfectionCount, 
MAX ((total_cases/population_density)) * 100 AS PercentPopulationInfected 
from [PortfolioProject ]..CovidDeaths$ 
--Where location like '%states%'
Group by Location, population_density
order by PercentPopulationInfected desc  


-- Showing Countries with Highest Death Count per Population 


-- LET'SBREAK THING DOWN BY CONTINENT 


Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount 
from [PortfolioProject ]..CovidDeaths$ 
--Where location like '%states%'
Where continent is not null 
Group by continent
Order by TotalDeathCount desc 


-- Showing continents with the highest death count per population 

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount 
from [PortfolioProject ]..CovidDeaths$ 
--Where location like '%states%'
Where continent is not null 
Group by continent
Order by TotalDeathCount desc




-- GLOBAL NUMBERS 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM (New_Cases)*100 as DeathPercentage 
from [PortfolioProject ]..CovidDeaths$ 
--Where location like '%states%' 
Where continent is not null
--Group By date 
order by 1,2    

-- Looking at Total Population vs Vaccinations 
With PopvsVac (Continent, Location, Date, Population_density, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population_density)*100 
From [PortfolioProject ]..CovidDeaths$ dea
Join [PortfolioProject ]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population_desnity)*100 
From PopsvsVac 


-- TEMP TABLE

DROP Table if exists #PercentPopuationVaccinated  
Create Table #PercentPopuationVaccinated
(
Continent nvarchar (255),
Location nvarchar(255),
Date datetime
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric 
)


Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population_density)*100 
From [PortfolioProject ]..CovidDeaths$ dea
Join [PortfolioProject ]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not null 
--order by 2,3 

Select *
From PercentPopuationVaccinated  


Select *, (RollingPeopleVaccinated/Population_desnity)*100 
From #PercentPopuationVaccinated



-- Creating View to sotre data for later visualizations

Create View #PercentPopuationVaccinated as 

Create 

-- USE CTE 

With PopvsVac 
