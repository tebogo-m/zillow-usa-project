--model uses CTEs and Window Functions to establish how long it took the average home value across the top 10 worst-performing states
--to recover/achieve the same inflation-adjusted dollar value they had in 2006
--model first finds the top 10 states based on the largest percentage decline in their ('Z1BR'/1 bedroom home) average value between 2007 and 2012
--model then finds the nominal home values for these states in the year 2006 for the 'Z1BR' indicator to establish a pre-decline baseline
--model then retrieves annual Consumer Price Index (CPI) data from a dbt seed to facilitate inflation adjustments to determine a real value
--model uses a window function (row_number partitioned by state and ordered by year) to find the earliest year after 2012 where each state's 'Z1BR' average home value equaled 
--or surpassed its inflation-adjusted 2006 baseline
--final select statement filters to show only this first recovery year for each state, ensuring unique results, and includes both the original and inflation-adjusted 2006 values
--final output also calculates the recovery duration both from the 2006 baseline and from the 2012 low point

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
CPI_LOOKUP AS (
    SELECT
        EXTRACT(YEAR FROM observation_date) AS CPI_YEAR,
        AVG(CPIAUCSL) AS ANNUAL_CPI_VALUE
    FROM {{ ref('usa_cpi_data_1996_to_2024') }}
    GROUP BY
        EXTRACT(YEAR FROM observation_date)
),
RECOVERY_YEARS AS (
    SELECT
        allbr.STATE,
        allbr.VALUATION_YEAR AS FIRST_RECOVERY_YEAR,
        allbr.AVG_HOME_VALUE,
        s06.HOME_VALUE_2006,
        ROUND((s06.HOME_VALUE_2006 * (cpi_current.ANNUAL_CPI_VALUE / cpi_2006.ANNUAL_CPI_VALUE)),2) AS INFLATION_ADJUSTED_2006_VALUE,
        ROW_NUMBER() OVER (PARTITION BY allbr.STATE ORDER BY allbr.VALUATION_YEAR ASC) AS rn
    FROM
        {{ ref('gold_zillow_home_values_states_allbr_py') }} allbr
    JOIN
        TOP_10_DECLINING_STATES top_states
            ON allbr.STATE = top_states.STATE
    JOIN
        STATE_2006_VALUES s06
            ON allbr.STATE = s06.STATE
    JOIN
        CPI_LOOKUP cpi_2006
            ON cpi_2006.CPI_YEAR = 2006
    JOIN
        CPI_LOOKUP cpi_current
            ON cpi_current.CPI_YEAR = allbr.VALUATION_YEAR
    WHERE
        allbr.AVG_HOME_VALUE >= (s06.HOME_VALUE_2006 * (cpi_current.ANNUAL_CPI_VALUE / cpi_2006.ANNUAL_CPI_VALUE))
        AND allbr.INDICATOR_ID = 'Z1BR'
        AND allbr.VALUATION_YEAR > 2012
)
SELECT
    STATE,
    FIRST_RECOVERY_YEAR,
    AVG_HOME_VALUE AS RECOVERY_YEAR_HOME_VALUE,
    HOME_VALUE_2006 AS ORIGINAL_2006_HOME_VALUE,
    INFLATION_ADJUSTED_2006_VALUE,
    (FIRST_RECOVERY_YEAR - 2006) AS TOTAL_YEARS_TO_RECOVER, 
    (FIRST_RECOVERY_YEAR - 2012) AS YEARS_TO_RECOVER_POST_2012
FROM
    RECOVERY_YEARS
WHERE
    rn = 1
ORDER BY
    STATE
    