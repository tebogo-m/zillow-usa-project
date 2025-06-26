-- model joins the home values table with the newly formed metros region table using region_id
-- the data is then ordered by indicator_id in descending order (eg Z4BR. Z3BR, Z2BR, Z1BR)
-- data for the USA as a whole is obtained via a specific 'metro' region_id hence the need to segment by metro at this stage

SELECT 
    metros.region_id,
    home_values.indicator_id,
    metros.metro,
    metros.state_abbr,
    home_values.date,
    home_values.home_value
FROM
    {{ref('silver_zillow_home_values')}} AS home_values
JOIN
    {{ref('silver_zillow_regions_metros')}} AS metros
ON
    home_values.region_id = metros.region_id
ORDER BY 
    home_values.indicator_id DESC