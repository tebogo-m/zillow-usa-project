-- model extracting data from 'zillow_home_values' table , specified in zillow_sources.yml file, to create a 1:1 relationship with the raw dataset 
-- value column aliased as home_value to improve readability and clarity in downstream models
SELECT
    indicator_id,
    region_id,
    date,
    value AS home_value
FROM 
    {{ source ('bronze', 'zillow_home_values') }}