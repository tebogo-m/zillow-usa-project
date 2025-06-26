SELECT
    region_id,
    SPLIT_PART(region_info, ';', 1) AS city,
    SPLIT_PART(region_info, ';', 2) AS state_abbr,
FROM {{ref ('bronze_zillow_regions') }}
WHERE region_type = 'city'