-- Probability of dying in Senegal
-- select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRate
-- from CovidDeaths
-- where location like 'senegal'
-- order by 1,3


-- Infection rate in Senegal
-- select location, date, total_cases, population, (total_cases/population)*100 as InfectionRate
-- from CovidDeaths
-- where location like 'senegal'
-- order by 1,3


-- Looking at highest infection rate compared to population
-- select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as InfectionRate
-- from CovidDeaths
-- where location like 'senegal'
-- group by location, population
-- order by infectionrate desc


-- Highest death count per continent
-- select continent, max(cast(total_deaths as int)) as DeathCount
-- from CovidDeaths
-- where continent is not NULL
-- group by continent
-- order by deathcount desc


-- Global numbers
-- select date, sum(new_cases) as total_cases, sum(cast(new_deaths as INT)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathRate
-- from CovidDeaths
-- -- where continent is not NULL:
-- order by 1, 2


-- Joining death & vaccination tables 
-- select *
-- from CovidDeaths
-- join CovidVaccinations
-- on CovidDeaths.location = CovidVaccinations.location
-- and CovidDeaths.date = CovidVaccinations.date


-- Looking at total population vs vaccinations
-- select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, 
-- CovidVaccinations.new_vaccinations, 
-- sum(CovidVaccinations.new_vaccinations) over (PARTITION by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date)as RollingVaccinations
-- from CovidDeaths
-- join CovidVaccinations
-- on CovidDeaths.location = CovidVaccinations.location
-- and CovidDeaths.date = CovidVaccinations.date
-- where CovidDeaths.continent is not null
-- order by 2, 3 asc


-- CTE method
-- with PopvsVac (continent, location, date, population, new_vaccinations, RollingVaccinations)
-- as
-- (
-- select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, 
-- CovidVaccinations.new_vaccinations, 
-- sum(CovidVaccinations.new_vaccinations) over (PARTITION by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date)as RollingVaccinations
-- from CovidDeaths
-- join CovidVaccinations
-- on CovidDeaths.location = CovidVaccinations.location
-- and CovidDeaths.date = CovidVaccinations.date
-- where CovidDeaths.continent is not null
-- )
-- 
-- SELECT *
-- from PopvsVac


-- Temp table method
-- create table NewTable
-- (
-- Continent nvarchar (255),
-- Location nvarchar (255),
-- Date datetime,
-- Population numeric,
-- New_vaccinations numeric,
-- RollingVaccinations NUMERIC
-- )
-- 
-- Insert into NewTable
-- select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, 
-- CovidVaccinations.new_vaccinations, 
-- sum(CovidVaccinations.new_vaccinations) over (PARTITION by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date)as RollingVaccinations
-- from CovidDeaths
-- join CovidVaccinations
-- on CovidDeaths.location = CovidVaccinations.location
-- and CovidDeaths.date = CovidVaccinations.date
-- where CovidDeaths.continent is not null
-- 
-- select *, (RollingVaccinations/population)*100 as VaccinationRate
-- from NewTable


-- Create View snMonthlyCases as
-- SELECT year, month, sum(new_cases) as MonthlyCases
-- from CovidDeaths2
-- where location like '%senegal%'
-- group by year, month

-- Create View frMonthlyCases as
-- SELECT year, month, sum(new_cases) as MonthlyCases
-- from CovidDeaths2
-- where location like '%france%'
-- group by year, month

-- Create View frPopulationContamination as
-- select location, date,(total_cases/population)*100 as ContaminationRate,(total_deaths/total_cases)*100 as DeathRate
-- from CovidDeaths 
-- where location like '%france%'
-- order by 1,3

-- Create view snMonthlyCases as
-- SELECT year, month, sum(new_cases) as MonthlyCases
-- from CovidDeaths2
-- where location like '%senegal%'
-- group by year, month

-- Create view monthly %change
-- create view snMonthlyPercentageChanges as
-- select year, Month, MonthlyCases,
-- lag(MonthlyCases) over(partition by year order by month) as PreviousCases,
-- ((MonthlyCases/lag(MonthlyCases) over(partition by year order by month))-1)*100 as PercentageChange
-- from snMonthlyCases

-- CREATE view snDailyPercentageChanges as
-- select location, year, date, new_Cases,
-- lag(new_Cases) over(partition by year) as PreviousCasesDaily,
-- ((new_Cases/lag(new_Cases) over(partition by year))-1)*100 as PercentageChange
-- from CovidDeaths2
-- where location like'%senegal%'

-- CREATE view frDailyPercentageChanges as
-- select location, year, date, new_Cases,
-- lag(new_Cases) over(partition by year) as PreviousCasesDaily,
-- ((new_Cases/lag(new_Cases) over(partition by year))-1)*100 as PercentageChange
-- from CovidDeaths2
-- where location like'%france%'


-- CREATE view snFullVAXDailyPercentageChanges as
-- select 
-- CovidDeaths2.location, 
-- CovidDeaths2.date, 
-- CovidVaccinations.people_fully_vaccinated
-- ,lag(CovidVaccinations.people_fully_vaccinated) over(partition by CovidDeaths2.year order by CovidDeaths2.location) as PreviousVaxDaily
-- ,((CovidVaccinations.people_fully_vaccinated/lag(CovidVaccinations.people_fully_vaccinated) over(partition by CovidDeaths2.year))-1)*100 as VAXPercentageChange
-- ,lag(CovidDeaths2.new_Cases) over(partition by CovidDeaths2.year) as PreviousCasesDaily
-- ,((CovidDeaths2.new_Cases/lag(CovidDeaths2.new_Cases) over(partition by CovidDeaths2.year))-1)*100 as ContaminationPercentageChange
-- from CovidDeaths2
-- join CovidVaccinations
-- on CovidDeaths2.date = CovidVaccinations.date
-- and CovidDeaths2.location = CovidVaccinations.location
