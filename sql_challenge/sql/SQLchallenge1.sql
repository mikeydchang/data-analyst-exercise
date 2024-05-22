-- SQL Challenge #1: Data Integrity & Cleanup
-- Select country codes, replacing NULL values with 'N/A'
SELECT
    COALESCE(country_code, 'N/A') AS country_code
FROM
    continent_map
-- Group by country code to count occurrences
GROUP BY
    COALESCE(country_code, 'N/A')
-- Only include codes that appear more than once
HAVING
    COUNT(*) > 1
-- Order the results, with 'N/A' appearing first, followed by alphabetical order
ORDER BY
    CASE WHEN COALESCE(country_code, 'N/A') = 'N/A' THEN 0 ELSE 1 END,
    country_code;
