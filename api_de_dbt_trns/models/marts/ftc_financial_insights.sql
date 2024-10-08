{{ config(materialized='view') }}

WITH financial_insights AS (
    SELECT
        id,
        uid,
        credit_card_cc_number,
        subscription_plan,
        subscription_payment_method,
        CASE
            WHEN LOWER(subscription_plan) = 'gold' THEN 29.99
            WHEN LOWER(subscription_plan) = 'silver' THEN 19.99
            WHEN LOWER(subscription_plan) = 'bronze' THEN 9.99
            ELSE 0
        END AS monthly_revenue
    FROM {{ ref('stg_data_cleaning_standard') }}
)

SELECT * FROM financial_insights
