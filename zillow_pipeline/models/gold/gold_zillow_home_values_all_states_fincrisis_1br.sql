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