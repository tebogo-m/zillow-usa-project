-- model calculates the average home value for a specific indicator within each of the US states
-- this is calculated for each of the years available in the datatset (year is extracted from the date column)
-- the data is initially grouped by state, then indicator id, then valuation year to ensure the calculation is carried out for each specific indicator id in each state within a specific year
-- the result set is then ordered with the valuation year in descending order to ensure the most recent years appear first 
-- the final amount is rounded off to 2 decimal places

SELECT 
    YEAR(DATE) AS VALUATION_YEAR,
    STATE,
    INDICATOR_ID,
    ROUND(AVG(HOME_VALUE),2) AS AVG_HOME_VALUE
FROM 
    {{ref('silver_zillow_home_values_states')}}
GROUP BY 
    STATE,
    INDICATOR_ID,
    VALUATION_YEAR
ORDER BY 
    STATE,
    INDICATOR_ID,
    VALUATION_YEAR DESC