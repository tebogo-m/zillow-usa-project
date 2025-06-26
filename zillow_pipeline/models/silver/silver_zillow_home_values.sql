-- model selecting all rows where indicator id's match the 'Z_BR' format
-- 'Z_BR' indicators will allow for the segmentation of the data by bedroom numbers (eg. Z1BR = 1 bedroom) in downstream models

SELECT
    indicator_id,
    region_id,
    date,
    home_value
FROM 
    {{ref('bronze_zillow_home_values') }} as home_values
WHERE
    indicator_id LIKE 'Z%BR'
