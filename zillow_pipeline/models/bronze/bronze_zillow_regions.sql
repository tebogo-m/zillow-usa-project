-- model extracting data from 'zillow_regions' table, specified in zillow_sources.yml file, to create a 1:1 relationship with the raw dataset 
-- 'region' column aliased as 'region_info' to improve readability and clarity in downstream models

SELECT 
    region_id,
    region_type,
    region AS region_info
FROM
    {{ source ('bronze', 'zillow_regions') }}