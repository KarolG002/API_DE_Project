{{ config(materialized='view') }}

WITH geospatial_analysis AS (
    SELECT
        id,
        address_city,
        address_state,
        address_country,
        address_coordinates_lat,
        address_coordinates_lng,
        ST_GEOGPOINT(address_coordinates_lng, address_coordinates_lat) AS geo_point
    FROM {{ ref('stg_data_cleaning_standard') }}
)

SELECT * FROM geospatial_analysis