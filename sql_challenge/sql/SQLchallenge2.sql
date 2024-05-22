-- SQL Challenge #2: List the Top 10 Countries by year over year % GDP per capita growth between 2011 & 2012.
-- The CTE calculates the year-over-year GDP per capita growth between 2011 and 2012.
WITH gdp_growth AS (
    SELECT
        gdp_2012.country_code,
        countries.country_name,
        continent_map.continent_code,
        ((gdp_2012.gdp_per_capita - gdp_2011.gdp_per_capita) / gdp_2011.gdp_per_capita * 100) AS growth_percent
    FROM
        per_capita AS gdp_2012
    JOIN
        per_capita AS gdp_2011 ON gdp_2012.country_code = gdp_2011.country_code AND gdp_2011.year = 2011
    JOIN
        countries ON gdp_2012.country_code = countries.country_code
    JOIN
        continent_map ON countries.country_code = continent_map.country_code
    WHERE
        gdp_2012.year = 2012
        AND gdp_2012.gdp_per_capita IS NOT NULL
        AND gdp_2011.gdp_per_capita IS NOT NULL
)

-- Main query to rank and select the top 10 countries
SELECT
    RANK() OVER (ORDER BY growth_percent DESC) AS rank,
    gdp_growth.country_name,
    gdp_growth.country_code,
    continents.continent_name AS continent,
    gdp_growth.growth_percent
FROM
    gdp_growth
JOIN
    continents ON gdp_growth.continent_code = continents.continent_code
ORDER BY
    growth_percent DESC
LIMIT 10;
