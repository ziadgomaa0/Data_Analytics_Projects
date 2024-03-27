Select *
From Portofolio_Project..deaths
where continent is not null
order by 3,4

--Select *
--From Portofolio_Project..vacine
--order by 3,4

-- Select data we are going to use 
--Select Location,date, total_cases , new_cases , total_deaths , population
--From Portofolio_Project..deaths
--order by 1,2

-- Looking at total cases vs totals deaths 

--Select Location,date, total_cases  , total_deaths , ( CAST (total_deaths AS FLOAT ) / total_cases ) *100 as DeathPercentage , (total_cases /population)*100 as InfectedPercentage
--From Portofolio_Project..deaths
--where location like '%states%'
--order by 1,2
-- casting problem 
--  column1 / CAST(column2 AS FLOAT) AS result  - 


 --looking at the countries with the highest infection rate 

-- Select Location,MAX( total_cases)as highestinfectioncount ,MAX ( CAST (total_deaths AS FLOAT ) / total_cases ) *100 as DeathPercentage 
--From Portofolio_Project..deaths
--Group by Location, Population 
--order by DeathPercentage desc



 Select Location,MAX( cast(total_deaths as int))as highestdeathcount 
From Portofolio_Project..deaths
where continent is not null
Group by Location 
order by highestdeathcount desc


 Select Location,MAX( cast(total_deaths as int))as highestdeathcount 
From Portofolio_Project..deaths
where continent is null
Group by Location 
order by highestdeathcount desc

-- GLOBAL NUMBERS

Select date,SUM(cast(total_cases as float )) -- , total_deaths , ( CAST (total_deaths AS FLOAT ) / total_cases ) *100 as DeathPercentage 
From Portofolio_Project..deaths
--where continent is not null 
Group by date
order by 1,2

--- exploring Total population Vs Vaccincations 
select *
From Portofolio_Project..deaths
Join Portofolio_Project..vacine 
On deaths.location = vacine.location 
and deaths.date = vacine.date 

select deaths.continent , deaths.location , deaths.date ,deaths.population , vacine.new_vaccinations
From Portofolio_Project..deaths
Join Portofolio_Project..vacine 
On deaths.location = vacine.location 
and deaths.date = vacine.date 
where deaths.continent is not null 
order by 2,3



--another way to sum them up i a new column
select deaths.continent , deaths.location , deaths.date ,deaths.population , vacine.new_vaccinations ,
sum (convert (bigint,vacine.new_vaccinations)) OVER (partition by deaths.location ORDER BY deaths.location )
From Portofolio_Project..deaths
Join Portofolio_Project..vacine 
On deaths.location = vacine.location 
and deaths.date = vacine.date 
where deaths.continent is not null 
order by 2,3

-- don't fogret to drop table if exists 
Drop table if exists #PercentPopulationvacinnated
create table #PercentPopulationvacinnated
{
Continent nvrchar(255),
location nvrchar(255)
date datetime
population numeric,
new_vanccinations numeric , 
Rolling_people_Vaccinated numeric 
}



-- Creatiing View to store data for later visualization 

Create view PercPopulationVacnine as
select deaths.continent , deaths.location , deaths.date ,deaths.population , vacine.new_vaccinations ,
sum (convert (bigint,vacine.new_vaccinations)) OVER (partition by deaths.location ORDER BY deaths.location ) as RollingpeopleVacine
From Portofolio_Project..deaths
Join Portofolio_Project..vacine 
On deaths.location = vacine.location 
and deaths.date = vacine.date 
where deaths.continent is not null 
--order by 2,3


DROP VIEW PercPopulationVacnine ;





