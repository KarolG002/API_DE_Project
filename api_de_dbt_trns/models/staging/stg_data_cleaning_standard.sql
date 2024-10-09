WITH raw_data AS (
    SELECT 
        id,
        uid,
        username,
        {{ clean_email('email') }} AS email,  -- Clean and normalize email
        gender,
        {{ clean_phone_number('phone_number') }} AS phone_data,  -- Clean phone number using macro
        SAFE_CAST(date_of_birth AS DATE) AS date_of_birth,  -- Cast date_of_birth to DATE type
        employment_title,
        address_city,
        address_street_name,
        address_street_address,
        address_zip_code,
        address_state,
        address_country,
        address_coordinates_lat,
        address_coordinates_lng,
        {{ mask_credit_card('credit_card_cc_number') }} AS credit_card_cc_number,  -- Mask credit card number
        subscription_plan,
        subscription_status,
        subscription_payment_method,
        subscription_term
    FROM {{ source('user_data_source', 'api_data') }}
),

normalized_phone_data AS (
    SELECT
        id,
        uid,
        username,
        email,
        gender,
        -- Split the phone_data into main number and extension
        SPLIT(phone_data, 'x')[OFFSET(0)] AS main_phone,
        CASE 
            WHEN ARRAY_LENGTH(SPLIT(phone_data, 'x')) > 1 
            THEN SPLIT(phone_data, 'x')[OFFSET(1)] 
            ELSE NULL 
        END AS extension,
        date_of_birth,
        employment_title,
        address_city,
        address_street_name,
        address_street_address,
        address_zip_code,
        address_state,
        address_country,
        address_coordinates_lat,
        address_coordinates_lng,
        credit_card_cc_number,
        subscription_plan,
        subscription_status,
        subscription_payment_method,
        subscription_term
    FROM raw_data
),

formatted_phone_data AS (
    SELECT
        *,
        -- Ensure formatting of phone numbers
        CASE
            WHEN LENGTH(main_phone) = 10 THEN 
                CONCAT(SUBSTR(main_phone, 1, 3), '-', SUBSTR(main_phone, 4, 3), '-', SUBSTR(main_phone, 7, 4))
            WHEN LENGTH(main_phone) > 10 THEN
                CONCAT('+', SUBSTR(main_phone, 1, LENGTH(main_phone) - 10), '-', SUBSTR(main_phone, -10, 3), '-', SUBSTR(main_phone, -7, 3), '-', SUBSTR(main_phone, -4))
            ELSE main_phone
        END AS formatted_phone
    FROM normalized_phone_data
),

final_data AS (
    SELECT
        id,
        uid,
        username,
        email,
        gender,
        formatted_phone,
        extension,
        date_of_birth,
        employment_title,
        CONCAT(
            COALESCE(address_street_address, ''),
            CASE WHEN address_street_name IS NOT NULL THEN ', ' || address_street_name ELSE '' END,
            CASE WHEN address_city IS NOT NULL THEN ', ' || address_city ELSE '' END,
            CASE WHEN address_state IS NOT NULL THEN ', ' || address_state ELSE '' END,
            CASE WHEN address_zip_code IS NOT NULL THEN ', ' || address_zip_code ELSE '' END,
            CASE WHEN address_country IS NOT NULL THEN ', ' || address_country ELSE '' END
        ) AS full_address,
        address_coordinates_lat,
        address_coordinates_lng,
        credit_card_cc_number,
        subscription_plan,
        subscription_status,
        subscription_payment_method,
        subscription_term
    FROM formatted_phone_data
)

SELECT * FROM final_data