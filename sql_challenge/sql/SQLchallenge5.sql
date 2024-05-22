-- SQL Challenge #5: Calculate the median GDP per capita for every continent for every year from 2004 through 2012
WITH ranked_gdp AS (
    -- Selecting year, continent name, GDP per capita, and ranking the GDP per capita within each continent and year
    SELECT
        p.year,
        co.continent_name AS continent,
        p.gdp_per_capita,
        ROW_NUMBER() OVER (PARTITION BY p.year, co.continent_code ORDER BY p.gdp_per_capita) AS row_num,
        COUNT(*) OVER (PARTITION BY p.year, co.continent_code) AS total_rows
    FROM
        per_capita p -- Main table: per_capita
    JOIN
        continent_map cm ON p.country_code = cm.country_code -- Joining per_capita with continent_map table on country_code to get continent_code
    JOIN
        continents co ON cm.continent_code = co.continent_code -- Joining continent_map with continents table on continent_code to get continent_name
    WHERE
        p.year BETWEEN 2004 AND 2012 -- Filtering data for years 2004 through 2012
)
-- Main query to select year, continent, and calculate the median GDP per capita based on the ranked data
SELECT
    year, -- Selecting the year
    continent, -- Selecting the continent
    AVG(gdp_per_capita) AS median_gdp_per_capita -- Calculating the average of GDP per capita values, which approximates the median
FROM (
    -- Subquery to filter the ranked GDP data to include only rows where the row number is either the middle row or the row just after the middle row
    SELECT
        year,
        continent,
        gdp_per_capita,
        total_rows,
        CASE
            WHEN total_rows % 2 = 1 THEN
                CASE
                    WHEN row_num = (total_rows + 1) / 2 THEN 1
                END
            WHEN total_rows % 2 = 0 THEN
                CASE
                    WHEN row_num IN (total_rows / 2, total_rows / 2 + 1) THEN 1
                END
        END AS is_median
    FROM
        ranked_gdp
) AS filtered_data
WHERE
    is_median = 1 -- Filtering data to include only rows representing the median
GROUP BY
    year, continent -- Grouping the results by year and continent
ORDER BY
    year, continent; -- Ordering the results by year and continent
