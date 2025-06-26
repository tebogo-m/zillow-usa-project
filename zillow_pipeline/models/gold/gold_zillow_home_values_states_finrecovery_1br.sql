-- model uses CTEs and Window Functions to establish how long it took the average home value across the top 10 worst performing states to recover/ achieve the nominal value they had in 2006
-- model first finds the top 10 worst performing states based on the largest percentage decline in their 'Z1BR' (1 bedroom home) average value between 2007 and 2012
-- model then finds the home values for these states in the year 2006 for the 'ZIBR/1 bedroom home' indicator to establish a pre-decline baseline
-- model then uses a window function (row number partitioned by state and ordered by year) to find the earliest year after 2012 where each state's 'Z1BR/1 bedroom' average home value
-- equaled or surpassed its 2006 baseline.
-- final select statement filters to show only this first recovery year for each state, ensuring unique results
-- final output also calculates the recovery duration both from the 2006 baseline and from the 2012 low point


WITH TOP_10_DECLINING_STATES AS (
    SELECT
        t2007.STATE,
        ROUND((t2012.AVG_HOME_VALUE - t2007.AVG_HOME_VALUE) * 100.0 / t2007.AVG_HOME_VALUE, 2) AS PERCENTAGE_CHANGE
    FROM
        {{ ref('gold_zillow_home_values_states_allbr_py') }} t2007
    JOIN
        {{ ref('gold_zillow_home_values_states_allbr_py') }} t2012
            ON t2007.STATE = t2012.STATE
            AND t2007.INDICATOR_ID = t2012.INDICATOR_ID
    WHERE
        t2007.VALUATION_YEAR = 2007
        AND t2012.VALUATION_YEAR = 2012
        AND t2007.INDICATOR_ID = 'Z1BR'
    ORDER BY
        PERCENTAGE_CHANGE ASC
    LIMIT 10
),
STATE_2006_VALUES AS (
    SELECT
        STATE,
        AVG_HOME_VALUE AS HOME_VALUE_2006
    FROM
        {{ ref('gold_zillow_home_values_states_allbr_py') }}
    WHERE
        VALUATION_YEAR = 2006
        AND INDICATOR_ID = 'Z1BR'
),
RECOVERY_YEARS AS (
    SELECT
        allbr.STATE,
        allbr.VALUATION_YEAR,
        allbr.AVG_HOME_VALUE,
        s06.HOME_VALUE_2006,
        ROW_NUMBER() OVER (PARTITION BY allbr.STATE ORDER BY allbr.VALUATION_YEAR ASC) AS rn
    FROM
        {{ ref('gold_zillow_home_values_states_allbr_py') }} allbr
    JOIN
        TOP_10_DECLINING_STATES top_states
            ON allbr.STATE = top_states.STATE
    JOIN
        STATE_2006_VALUES s06
            ON allbr.STATE = s06.STATE
    WHERE
        allbr.AVG_HOME_VALUE >= s06.HOME_VALUE_2006
        AND allbr.INDICATOR_ID = 'Z1BR'
        AND allbr.VALUATION_YEAR > 2012
)
SELECT
    STATE,
    VALUATION_YEAR AS FIRST_RECOVERY_YEAR,
    AVG_HOME_VALUE,
    HOME_VALUE_2006,
    (VALUATION_YEAR - 2006) AS TOTAL_YEARS_TO_RECOVER,
    (VALUATION_YEAR - 2012) AS YEARS_TO_RECOVER_POST_2012
FROM
    RECOVERY_YEARS
WHERE
    rn = 1
ORDER BY
    STATE