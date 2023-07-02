Select *
From PortafolioProject..CovidDeaths
Where continent is not null
Order by 3,4

--Select *
--From PortafolioProject..CovidVaccinations
--Order by 3,4

Select location, date, total_cases,new_cases,total_deaths, population
From PortafolioProject..CovidDeaths
Where continent is not null
Order by 1,2

--Total cases vs Total Deaths

Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortafolioProject..CovidDeaths
--Where location like 'Colombia'
Where continent is not null
Order by 1,2

--Total cases vs Population

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortafolioProject..CovidDeaths
--Where location like 'Colombia'
Order by 1,2


-- Countries with highest infection rate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as 
PercentPopulationInfected
From PortafolioProject..CovidDeaths
--Where location like 'Colombia'
Group by location, population
Order by PercentPopulationInfected desc


-- Countries with highest Death count per population

Select location, MAX(cast(total_deaths as int)) as HighestDeathCount
From PortafolioProject..CovidDeaths
Where continent is not null
Group by location
Order by HighestDeathCount desc


-- Continents with the highest death count per population 

Select continent, sum(cast(new_deaths as int)) as TotalDeathCount
From PortafolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc


-- GLOBAL NUMBERS
--Total cases vs Total Deaths

Select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortafolioProject..CovidDeaths
Where continent is not null
--Group by date
Order by 1,2


--Total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (Partition By dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 cannot do that
From PortafolioProject..CovidDeaths dea
Join PortafolioProject..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
where dea.continent is not null
Order by 2,3

--USE CTE

With PopvsVac (continent, location , date, population, new_vaccinations, RollingPeopleVaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (Partition By dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
From PortafolioProject..CovidDeaths dea
Join PortafolioProject..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 as RatePopulationVaccinated
From PopvsVac


--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (Partition By dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
From PortafolioProject..CovidDeaths dea
Join PortafolioProject..CovidVaccinations vac
	On dea.location = vac.location
	And dea.date = vac.date
where dea.continent is not null
Order by 2,3
Select *, (RollingPeopleVaccinated/Population)*100 as RatePopulationVaccinated
From #PercentPopulationVaccinated
