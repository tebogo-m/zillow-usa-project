-- metro is combined with the state in the region_info column and the two values are seperated by a comma (eg "metro, state_abbr")
-- model cleans the bronze_zillow_regions table in order to extract the 'metro' from the region_info
-- model will split the 'metro' and 'state' into 2 seperate columns and rename the columns as 'metro' for the 'metro' and 'state_abbr' for the state abbreviation
-- splitting the 2 columns allows metros to be easily referenced or utilised in downstream models

SELECT
    region_id,
    SPLIT_PART(region_info, ',', 1) AS metro,
    SPLIT_PART(region_info, ',', 2) AS state_abbr
FROM {{ref ('bronze_zillow_regions') }}
WHERE region_type = 'metro'