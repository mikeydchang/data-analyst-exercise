-- SQL Challenge #3: For the year 2012, compare the percentage share of GDP Per Capita for the following regions: North America (NA), Europe (EU), and the Rest of the World.
-- CTE to calculate total GDP per capita for each region in 2012
WITH region_gdp AS (
    -- Selecting region and sum of GDP per capita for each region
    SELECT
        CASE
            WHEN continent_map.continent_code = 'NA' THEN 'North America'
            WHEN continent_map.continent_code = 'EU' THEN 'Europe'
            ELSE 'Rest of the World'
        END AS region,
        SUM(per_capita.gdp_per_capita) AS total_gdp_per_capita
    FROM
        per_capita
    JOIN
        continent_map ON per_capita.country_code = continent_map.country_code
    WHERE
        per_capita.year = 2012
    GROUP BY
        region
)

-- Main query to calculate the percentage share of GDP per capita for each region
SELECT
    -- Calculate percentage share of GDP per capita for North America
    CONCAT(
        ROUND((north_america / total_gdp) * 100, 2), '%' -- Round and format the percentage
    ) AS "North America", -- Column for North America

    -- Calculate percentage share of GDP per capita for Europe
    CONCAT(
        ROUND((europe / total_gdp) * 100, 2), '%' -- Round and format the percentage
    ) AS "Europe", -- Column for Europe

    -- Calculate percentage share of GDP per capita for Rest of the World
    CONCAT(
        ROUND((rest_of_world / total_gdp) * 100, 2), '%' -- Round and format the percentage
    ) AS "Rest of the World" -- Column for Rest of the World
FROM (
    -- Subquery to aggregate GDP per capita data for each region
    SELECT
        -- Calculate sum of GDP per capita for North America
        SUM(CASE WHEN region = 'North America' THEN total_gdp_per_capita ELSE 0 END) AS north_america,
        -- Calculate sum of GDP per capita for Europe
        SUM(CASE WHEN region = 'Europe' THEN total_gdp_per_capita ELSE 0 END) AS europe,
        -- Calculate sum of GDP per capita for Rest of the World
        SUM(CASE WHEN region = 'Rest of the World' THEN total_gdp_per_capita ELSE 0 END) AS rest_of_world,
        -- Calculate total GDP per capita for all regions
        SUM(total_gdp_per_capita) AS total_gdp
    FROM
        region_gdp
) AS aggregated_data;
