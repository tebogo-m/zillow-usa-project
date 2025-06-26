-- model joins upstream tables for home values and states using region_id's
-- the data is then ordered by indicator_id in descending order (eg Z4BR. Z3BR, Z2BR, Z1BR)
-- this is done in order to be able to obtain home values in each state throughout the years available in the dataset

SELECT 
    states.region_id,
    home_values.indicator_id,
    states.state,
    home_values.date,
    home_values.home_value
FROM
    {{ref('silver_zillow_home_values')}} AS home_values
JOIN
    {{ref('silver_zillow_regions_states')}} AS states
ON
    home_values.region_id = states.region_id
ORDER BY 
    home_values.indicator_id DESC