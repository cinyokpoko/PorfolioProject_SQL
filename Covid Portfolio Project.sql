Select *
From CovidDeaths
Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Order by 1,2

--Percentage of the Nigerian Population that contacted Covid
Select location, date, population, total_cases, (total_cases/population)*100 as PecentageOfCases
From CovidDeaths
where total_cases is not null and population is not null and location like '%Nigeria%'
Order by 1,2

--Percentage of Total Deaths to Total Cases.
--Chances of getting Covid in Nigeria.
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PecentageOfDeath
From CovidDeaths
where total_cases is not null and total_deaths is not null and location like '%Nigeria%'
Order by 1,2

--Countries with highest cases as compared to their population
Select location, population, Max(total_cases) as highestCaseValues, Max((total_cases/population))*100 as PecentageOfCases
From CovidDeaths
where total_cases is not null and population is not null
Group by location, population
Order by 4 DESC

--Countries with highest death counts
Select location, Max(total_deaths) as highestDeathValues
From CovidDeaths
where continent is not null
Group by location
Order by 2 DESC

--Continents with highest death counts
Select continent, Max(total_deaths) as highestDeathValues
From CovidDeaths
where continent is not null
Group by continent 
Order by 2 DESC

--Global percentage of new deaths to new cases
Select date, Sum(new_cases) as global_total_cases, Sum(new_deaths) as global_total_deaths, (Sum(new_deaths)/Sum(new_cases))*100 as PecentageOfDeath
From CovidDeaths
where new_cases > 0 and new_deaths > 0 and continent is not null
group by date
Order by 1

--number of total cases in the world
Select Sum(new_cases) as global_total_cases, Sum(new_deaths) as global_total_deaths, (Sum(new_deaths)/Sum(new_cases))*100 as PecentageOfDeath
From CovidDeaths
where new_cases > 0 and new_deaths > 0 and continent is not null
Order by 1


Select *
From CovidVaccinations
Order by 3,4

--Perentage of Total population to vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS Vaccination_sum
From CovidDeaths dea
Join CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null and dea.population is not null
Order by 2,3

--Temp Table of population vs Vaccination

Drop Table if Exists #Percent_Population_Vaccination
Create Table #Percent_Population_Vaccination
(Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Vaccination_Sum numeric
)

Insert into #Percent_Population_Vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS Vaccination_Sum
From CovidDeaths dea
Join CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null and dea.population is not null
Order by 2,3
 
 Select *, (Vaccination_Sum/Population)*100
 From #Percent_Population_Vaccination

 --Views
 Create View Percent_Population_Vaccination As
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) AS Vaccination_Sum
From CovidDeaths dea
Join CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null and dea.population is not null