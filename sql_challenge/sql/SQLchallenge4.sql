-- SQL Challenge #4: Calculate the average GDP per capita for every continent for every year from 2004 through 2012
SELECT
    p.year, -- Selecting the year from the per_capita table
    co.continent_name AS continent, -- Selecting the continent name from the continents table and aliasing it as 'continent'
    ROUND(SUM(p.gdp_per_capita) / COUNT(DISTINCT p.country_code), 2) AS average_gdp_per_capita -- Calculating the average GDP per capita for each continent and rounding the result to 2 decimal places
FROM
    per_capita p -- Main table: per_capita
JOIN
    continent_map cm ON p.country_code = cm.country_code -- Joining per_capita with continent_map table on country_code to get continent_code
JOIN
    continents co ON cm.continent_code = co.continent_code -- Joining continent_map with continents table on continent_code to get continent_name
WHERE
    p.year BETWEEN 2004 AND 2012 -- Filtering data for years 2004 through 2012
GROUP BY
    p.year, co.continent_name -- Grouping the data by year and continent name
ORDER BY
    p.year, co.continent_name; -- Ordering the results by year and continent name
