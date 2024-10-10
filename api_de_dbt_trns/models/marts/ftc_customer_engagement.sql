{{ config(materialized='view') }}

WITH customer_engagement AS (
    SELECT
        id,
        uid,
        username,
        email,
        subscription_status,
        subscription_term,
        CASE
            WHEN LOWER(subscription_term) = 'annual' THEN 5
            WHEN LOWER(subscription_term) = 'monthly' AND LOWER(subscription_status) = 'active' THEN 3
            WHEN LOWER(subscription_status) = 'active' THEN 2
            ELSE 1
        END AS engagement_score
    FROM {{ ref('stg_data_cleaning_standard') }}
)

SELECT * FROM customer_engagement
