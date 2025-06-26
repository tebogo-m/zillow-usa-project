-- model filters for the indicator id's that follow the Z_BR format
-- this model is used to obtain a view of all relevant indicator ids which will potentially be used throughout the project
SELECT
    indicator_id,
    indicator_name
FROM {{ref ('bronze_zillow_indicators')}}
WHERE indicator_id LIKE  'Z%BR' 