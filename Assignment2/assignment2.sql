--Angel Baez Assignment 2
--Question 2: The table country has non null attributes, namely indepyear, lifeexpectancy, gnp, gnpold, headofstate
--and capital. This prevents the database from being in 1NF. All other attributes for the country table
--and the other tables have non null constraints. If we are to ignore nulls as a 1NF condition, then the database
--would be in at least 2NF. The attributes for each table are atomic and describe the primary key of their 
--respective tables. The only issues with the schema is that countrycode in the city table should be a foreign key
--to the country table's primary key, code. Also, the attribute gnpold may stop the database from achieving 3NF.
--When the gnp is updated, then the gnpold must also be updated, which can be viewed as a dependency which must
--not exist in order to reach 3NF.

--1. What are the top ten countries by economic activity (Gross National Product - ‘gnp’)
SELECT	
	gnp AS top_ten_gnp, 
	name AS country_name, code 
FROM
	country
ORDER BY  
	gnp DESC
LIMIT 
	10;
	
--2. What are the top ten countries by GNP per capita? (watch out for division by zero here !)
SELECT	
	gnp/population AS top_ten_gnp_per_capita, 
	name AS country_name, code
FROM
	country
WHERE	
	population <> 0
ORDER BY  
	gnp/population DESC
LIMIT 
	10;
	
--3. What are the ten most densely populated countries, and ten least densely populated countries?
SELECT	
	population / surfacearea AS top_ten_population_density,
	name AS country_name, code
FROM
	country
WHERE
	population <> 0 AND surfacearea <> 0
ORDER BY 
	population / surfacearea DESC
LIMIT
	10;
	
SELECT	
	population / surfacearea AS bottom_ten_population_density,
	name AS country_name, code
FROM
	country
WHERE
	population <> 0 AND surfacearea <> 0
ORDER BY 
	population / surfacearea
LIMIT
	10;
	
--4. What different forms of government are represented in this data? (‘DISTINCT’ keyword should help here.)
SELECT DISTINCT
	governmentform
AS	
	different_government_forms
FROM 
	country;
--Which forms of government are most frequent? (distinct, count, group by order by)	
SELECT DISTINCT
	governmentform AS most_frequent_gov_form, 
	count(governmentform) AS count_gov_form
FROM 
	country
GROUP BY 
	governmentform
ORDER BY
	count(governmentform) DESC;

--5. Which countries have the highest life expectancy? (watch for NULLs).
SELECT
	lifeexpectancy AS top_life_expectancy,
	code, name
FROM
	country
WHERE
	lifeexpectancy IS NOT NULL
ORDER BY 
	lifeexpectancy DESC;
	
--6. What are the top ten countries by total population, and what is the official language
--spoken there? (basic inner join)
SELECT
	population, countrylanguage.language AS official_language, 
	name
FROM	
	country INNER JOIN countrylanguage ON 
	country.code = countrylanguage.countrycode
WHERE
	countrylanguage.isofficial = true
ORDER BY 
	population DESC
LIMIT
	10;

--7. What are the top ten most populated cities – along with which country they are in,
--and what continent they are on? (basic inner join)
SELECT 
	city.name AS most_populated_cities, city.population,  
	country.continent, country.name
FROM 
	country INNER JOIN city ON
	country.code = city.countrycode
ORDER BY
	city.population DESC
LIMIT 
	10;

--8. What is the official language of the top ten cities you found in Question #7?
--(three-way inner join).
SELECT 
	city.name AS most_populated_cities, 
	countrylanguage.language AS official_language,  
	country.continent, country.name
FROM 
	country INNER JOIN city ON
	country.code = city.countrycode
	INNER JOIN countrylanguage ON
	country.code = countrylanguage.countrycode
WHERE
	countrylanguage.isofficial = true
ORDER BY
	city.population DESC
LIMIT 
	10;

--9. Which of the cities from Question #7 are capitals of their country?
--(requires a join and a subquery).
SELECT 
	city.name AS most_populated_capitals, city.population,  
	country.continent, country.name
FROM 
	country INNER JOIN city ON
	city.id = country.capital
WHERE 
	city.id IN (SELECT 
					city.id 
				FROM 
					city INNER JOIN country ON
					country.code = city.countrycode					
				ORDER BY
					city.population DESC
				LIMIT 
					10)				
ORDER BY
	city.population DESC;
	
--10. For the cities found in Question#9, what percentage of the country’s population
--lives in the capital city? (watch your int’s vs floats !).
SELECT 
	city.name AS most_populated_capitals, 
	CAST(city.population AS FLOAT) / 
	country.population * 100 AS pct_of_country_in_capital,  
	country.continent, country.name
FROM 
	country INNER JOIN city ON
	city.id = country.capital
WHERE 
	city.id IN (SELECT 
					city.id 
				FROM 
					city INNER JOIN country ON
					country.code = city.countrycode					
				ORDER BY
					city.population DESC
				LIMIT 
					10)				
ORDER BY
	city.population DESC;