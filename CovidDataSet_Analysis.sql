select * from [Portfolio Project]..CovidDeaths
order by 3,4;

select * from [Portfolio Project]..CovidDeaths
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population 
from [Portfolio Project]..CovidDeaths
order by 1,2;

--Death Percentage

select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
order by 1,2;

--Death Percentage in India

select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
where location like '%india%'
order by 1,2;

--Looking at Total Cases vs Population

--Shows what percentage of population got covid in India.

select location, date,total_cases, population,(total_cases/population)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
where location like '%india%'
order by 1,2;

--max infection_rate compared to population

select location, max(total_cases) as HIC, population,max((total_cases/population))*100 as PercentPopulationINfc
from [Portfolio Project]..CovidDeaths
--where location like '%india%'
group by location, population
order by  PercentPopulationINfc DESC;

--continents with highest death count

select continent, sum(cast(total_deaths as int)) as totalDeathCount
from [Portfolio Project]..CovidDeaths
where continent is not null
group by continent
order by totalDeathCount desc;

--Global NUMBERS

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as globalDeathPercent
from [Portfolio Project]..CovidDeaths
--where continent is not null
--group by continent
order by 1,2;


--Total Populations vs vaccinations

select dea.location, dea.continent,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.Date) as PeopleVacc
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
        On dea.location = vac.location
        and dea.date = vac.date
where dea.continent is not null
order by 2,3



select dea.location, dea.continent,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.Date) as PeopleVacc
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
        On dea.location = vac.location
        and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Total Vaccinations
select total_vaccinations from [Portfolio Project]..CovidVaccinations;

--Percentage of Vaccinations by Population in India

Select dea.location, vac.total_vaccinations,dea.population,(vac.total_vaccinations/dea.population)*100 as vaccPercent
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
        On dea.location = vac.location
        and dea.date = vac.date
where dea.continent is not null
order by 2,3;


--Using a CTE

With PopvsVacc (Continent, Location, Date, Population, New_Vaccinations, PeopleVacc)
as
(
select dea.location, dea.continent,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.Date) as PeopleVacc
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
        On dea.location = vac.location
        and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (PeopleVacc/Population)*100 as vaccPercent
from PopvsVacc