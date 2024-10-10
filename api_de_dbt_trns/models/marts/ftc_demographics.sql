{{ config(materialized='view') }}

WITH demographics AS (
    SELECT
        id,
        uid,
        gender,
        date_of_birth,
        DATE_DIFF(CURRENT_DATE(), date_of_birth, YEAR) AS age,
        CASE
            WHEN DATE_DIFF(CURRENT_DATE(), date_of_birth, YEAR) < 18 THEN 'Under 18'
            WHEN DATE_DIFF(CURRENT_DATE(), date_of_birth, YEAR) BETWEEN 18 AND 24 THEN '18-24'
            WHEN DATE_DIFF(CURRENT_DATE(), date_of_birth, YEAR) BETWEEN 25 AND 34 THEN '25-34'
            WHEN DATE_DIFF(CURRENT_DATE(), date_of_birth, YEAR) BETWEEN 35 AND 44 THEN '35-44'
            WHEN DATE_DIFF(CURRENT_DATE(), date_of_birth, YEAR) BETWEEN 45 AND 54 THEN '45-54'
            ELSE '55+'
        END AS age_group,
        employment_title,
        address_country
    FROM {{ ref('stg_data_cleaning_standard') }}
)

SELECT * FROM demographics