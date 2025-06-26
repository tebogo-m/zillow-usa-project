-- model finds the 10 states which saw the highest decline in average home values between 2007 and 2012 for the 1 bedroom home indicator ('ZIBR')
-- model uses a self-join to combine the 2007 and 2012 data from the larger dataset 'gold_zillow_home_values_states_allbr_py'
-- join uses both state and indicator id to ensure that rows are matched based on the same state and the same indicator id
-- percentage change is returned in ascending order which will show the states with the largest decline first
-- number of states returned in the results are limited to 10
-- results are rounded to 2 decimal places

SELECT
    t2007.STATE,
    ROUND((t2012.AVG_HOME_VALUE - t2007.AVG_HOME_VALUE) * 100.00 / t2007.AVG_HOME_VALUE, 2) AS Percentage_Change
FROM
    {{ref('gold_zillow_home_values_states_allbr_py')}} t2007
JOIN
    {{ref('gold_zillow_home_values_states_allbr_py')}} t2012
        ON t2007.STATE = t2012.STATE
        AND t2007.INDICATOR_ID = t2012.INDICATOR_ID
WHERE
    t2007.VALUATION_YEAR = 2007
    AND t2012.VALUATION_YEAR = 2012
    AND t2007.INDICATOR_ID = 'Z1BR'
ORDER BY
    Percentage_Change ASC
LIMIT 10

