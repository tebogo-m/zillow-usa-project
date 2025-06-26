WITH ALL_STATES AS (
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
        ALL_STATES top_states
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