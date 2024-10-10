{{ config(materialized='view') }}
WITH customer_profile AS (
    SELECT
        id,
        uid,
        username,
        email,
        gender,
        formatted_phone,
        date_of_birth,
        full_address,
        employment_title,
        -- Add any necessary transformations here
        DATE_DIFF(CURRENT_DATE(), date_of_birth, YEAR) AS age
    FROM {{ ref('stg_data_cleaning_standard') }}
)

SELECT * FROM customer_profile