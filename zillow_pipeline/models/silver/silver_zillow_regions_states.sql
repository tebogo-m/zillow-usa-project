-- model filters all region data (state, counties, metros, cities, zip codes) to only provide the rows that contain 'state' information
-- 'region_id's' for each state will be used in downstream models when joining models/tables (region_id is a primary key/foreign key)

SELECT
    region_id,
    region_info AS state
FROM {{ref ('bronze_zillow_regions') }}
WHERE region_type = 'state'

