                                  #Population by State Project 
							#(Data Cleaning and Exploratory Analysis)
#Inspect Dirty Data
select *
from pop_race_2019;


#Change values in hispanic column from 'hispanic' or 'not hispanic' to 'yes' and 'no' 

Select hispanic,
              CASE
                  WHEN hispanic = 'Hispanic or Latino' then 'yes'
                  ELSE 'no' 
                  End 
from pop_race_2019;
# remove SQL safe mode
SET sql_safe_updates= 0;

#UPdate table 
UPDATE pop_race_2019
SET hispanic = (CASE
                  WHEN hispanic = 'Hispanic or Latino' then 'yes'
                  ELSE 'no' 
                  End) ;
                  
	#Check Data UPDATE
				
SELECT *

FROM pop_race_2019;

# Replace part of string in race identity. For example 'American Indian or Alaska Native' to just 'American Indian'

select race, count(race)
from pop_race_2019

group by race
having race like '% A%';

select race, replace(replace(replace(race, 'American Indian or Alaska Native', 'American Indian'),
'Black or African American','Black'),'Asian or Pacific Islander','Asian' )
from pop_race_2019;

Update pop_race_2019
set race = replace(replace(replace(race, 'American Indian or Alaska Native', 'American Indian'),
'Black or African American','Black'),'Asian or Pacific Islander','Asian' );


select *
from pop_race_2019;

# Find Duplicates
select state_name, race, hispanic, population, concat(state_name,race,hispanic,population), 
         count(concat(state_name,race,hispanic,population))
from pop_race_2019  
group by state_name, race, hispanic, population, concat(state_name,race,hispanic,population)
having count(concat(state_name,race,hispanic,population)) > 1;

# Trim White Spaces
Update pop_race_2019
set state_name = trim(state_name);
Update pop_race_2019
set race = trim(race);
Update pop_race_2019
set hispanic = trim(hispanic);
Update pop_race_2019
set population = trim(population);
Update pop_race_2019
set state_total_population = trim(state_total_population);

select *
from pop_race_2019;

#Row_Number
select
Row_number()OVER( Order by state) as row_num, state,state_name,race, hispanic,population, state_total_population
from pop_race_2019;



-- Top 10 states by total population

select distinct state_name, state_total_population
from pop_race_2019
order by state_total_population desc
limit 10;


-- Percent of Population per race by State

select state_name, 
race, hispanic,
population, 
state_total_population,
round(population/state_total_population * 100,2) as percent_pop
from pop_race_2019
group by race, state_name, hispanic, population, state_total_population
order by state_name;



-- Rank total National population by race

select 
race,
 sum(population),
rank() over ( order by sum(population)desc) as ranking
from pop_race_2019
group by race
order by  race, ranking desc;



