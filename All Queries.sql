-- Show all the tables from Covid-19 Database
SELECT TABLE_NAME FROM [Covid-19 Project].INFORMATION_SCHEMA.TABLES;

-- Describe the table structure of the tables
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='WeeklyData'

-- or use this query to describe the table structure
exec sp_columns CovidData;

-- Show all the data from both tables
select * from CovidData;
select * from WeeklyData;

-- Join these two tables using the Country Name
select * from CovidData left join WeeklyData 
on CovidData.Country = WeeklyData.Country;

-- Top 10 countries which have the highest total cases
select top 10 Country, Total_Cases from CovidData 
order by Total_Cases desc;

-- Top 10 countries which have the highest number of deaths
select top 10 Country, Total_Deaths from CovidData 
order by Total_Deaths desc;

-- Top 10 countries by Percentage of People Affected
select top 10 Country, Total_Population, Total_Cases, 
round((Total_Cases/Total_Population)*100, 2) as Infection_Rate 
from CovidData 
order by Infection_Rate desc;

-- Top 10 countries by Death and Death Percentage according to Total Cases
select top 10 Country, Total_Cases, Total_Deaths, 
round((Total_Deaths/Total_Cases)*100,2) as Death_Rate
from CovidData
order by Total_Deaths desc;

-- Show the Death Rate and Infection Rate of India
select top 10 Country, Total_Population,
Total_Cases, round((Total_Cases/Total_Population)*100, 2) as Infection_Rate,
Total_Deaths, round((Total_Deaths/Total_Cases)*100,2) as Death_Rate
from CovidData where Country = 'India';

-- Show the total Percentage of Individuals who have taken Vaccination Tests in India
select Country, Total_Population, Total_Tests, 
round((Total_Tests/Total_Population)*100,2) as Test_Percentage 
from CovidData 
where Country = 'India';

-- How many of the Total People who had been affected are recovered now in India
select Country, Total_Cases, Total_Recovered, 
round((Total_Recovered/Total_Cases)*100,2) as Recovery_Rate 
from CovidData 
where Country = 'India';

-- What is the total number of deaths by total cases world wide? Also calculate the percentages
select 'World' as Place, sum(Total_Cases) as Cases, sum(Total_Deaths) as Deaths,
round((sum(Total_Deaths)/sum(Total_Cases)*100),3) as Death_Rate
from CovidData;

-- What is the Infection Rate of Covid-19 for the entire World?
select 'World' as Place, sum(Total_Population) as Total_Population, sum(Total_Cases) as Cases,
round((sum(Total_Cases)/sum(Total_Population)*100),2) as Infection_Rate
from CovidData;

-- How much percentage of the total cases has recovered? How many test were conducted in total? Calculate percentages as well.
select 'World' as Place, sum(Total_Population) as Total_Population, sum(Total_Tests) as Tests_Conducted,
round((sum(Total_Tests)/sum(Total_Population)*100),2) as Test_Rate,
sum(Total_Cases) as Cases, sum(Total_Recovered) as Recovered_People,
round((sum(Total_Recovered)/sum(Total_Cases)*100),2) as Recovery_Rate
from CovidData;

-- Out of all the Active Cases what percentage of these cases are Serious cases in the entire world?
select 'World' as Place, sum(Active_Cases) as Active_Cases, sum(Serious_Cases) as Serious_Cases, 
round((sum(Serious_Cases)/sum(Active_Cases))*100,2) as Serious_Rate,
round(((sum(Active_Cases)-sum(Serious_Cases))/sum(Active_Cases))*100,2) as Normal_Rate
from CovidData;

-- Top 5 countries which have maximum last 7 day cases
select top 5 Country, Last_7_Day_Cases from WeeklyData order by Last_7_Day_Cases desc;

-- Top 5 countries where the covid 19 cases are the lowest in the last 7 days and is not 0
select top 5 Country, Last_7_Day_Cases from WeeklyData where Last_7_Day_Cases > 0 order by Last_7_Day_Cases;

-- Get details of India from Weekly Data Table
select * from WeeklyData where Country = 'India';

-- Find the differece in percentage regarding the case changes in last 7 days and preceding 7 days in India
select Country, Last_7_Day_Cases, Preceding_7_Day_Cases, 
round(((Last_7_Day_Cases - Preceding_7_Day_Cases)/Preceding_7_Day_Cases)*100,2) as Percent_Difference 
from WeeklyData 
where Country = 'India';

-- Find the top 30 Countries where the Difference in Covid-19 cases have decreased in terms of percentage
select top 30 Country, Last_7_Day_Cases, Preceding_7_Day_Cases, 
round(((Last_7_Day_Cases - Preceding_7_Day_Cases)/Preceding_7_Day_Cases)*100,2) as Percent_Difference 
from WeeklyData 
where Preceding_7_Day_Cases != 0
order by Percent_Difference;

-- Find The Death Rate change in India according to Last 7 days and Preceding & days in Weekly Data
select Country, Last_7_Day_Deaths, Preceding_7_Day_Deaths, 
round(((Last_7_Day_Deaths - Preceding_7_Day_Deaths)/Preceding_7_Day_Deaths)*100,2) 
as Death_Difference_Percent
from WeeklyData 
where Country = 'India';

-- Find the top 5 Countries which have highest death rate according to lastest weekly data.
select top 5 Country, Last_7_Day_Deaths, Preceding_7_Day_Deaths,
case
	when Preceding_7_Day_Deaths = 0  then 0
    else round(((Last_7_Day_Deaths - Preceding_7_Day_Deaths)/Preceding_7_Day_Deaths)*100,2)
	end 
	as Death_Difference_Percent
from WeeklyData
order by Death_Difference_Percent desc;

-- Select important data from both tables where country is India
select c.Country, c.Total_Population, Total_Tests, Total_Cases, Total_Deaths, 
Total_Recovered, Last_7_Day_Cases 
from CovidData as c join WeeklyData as w on c.Country = w.Country where w.Country = 'India';