/*
Covid 19 Data Exploration

*/

Select *
From project..CovidDeaths
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From project..CovidDeaths
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths and calculate Deathpercentage

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From project..CovidDeaths
Where location='India'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From project..CovidDeaths
Where location='India'
order by 1,2 


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From project..CovidDeaths
--Where location like '%india%'
Group by Location, Population
order by PercentPopulationInfected desc

select location,population,date,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from project..CovidDeaths
Group By location,population,date
order by PercentPopulationInfected desc






-- Countries with Highest Death Count per Population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From project..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From project..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From project..CovidDeaths
where continent is not null 
order by 1,2


