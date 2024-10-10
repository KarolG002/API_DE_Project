{{ config(materialized='view') }}

WITH subscription_analytics AS (
    SELECT
        id,
        uid,
        subscription_plan,
        subscription_status,
        subscription_payment_method,
        subscription_term,
        CASE 
            WHEN LOWER(subscription_status) = 'active' THEN 1
            ELSE 0
        END AS is_active
    FROM {{ ref('stg_data_cleaning_standard') }}
)

SELECT * FROM subscription_analytics