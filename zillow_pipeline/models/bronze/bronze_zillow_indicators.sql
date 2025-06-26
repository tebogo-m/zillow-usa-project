-- model extracting data from 'zillow_indicators' table , specified in zillow_sources.yml file, to create a 1:1 relationship with the raw dataset 
-- 'indicator' column aliased as 'indicator_name' to improve readability and clarity in downstream models

SELECT 
    indicator_id,
    indicator AS indicator_name,
    category
FROM
      {{ source ('bronze', 'zillow_indicators') }}