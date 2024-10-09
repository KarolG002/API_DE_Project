WITH raw_data AS (
    SELECT 
        id,
        uid,
        username,
        {{ clean_email('email') }} AS email,  -- Apply clean email macro
        {{ clean_phone_number('phone_number') }} AS phone_data,  -- Apply clean phone number macro
        SAFE_CAST(date_of_birth AS DATE) AS date_of_birth,  -- Clean date_of_birth
        {{ mask_credit_card('credit_card_cc_number') }} AS credit_card_cc_number  -- Apply mask to credit card numbers
    FROM {{ source('user_data_source', 'api_data') }}
)

SELECT * FROM raw_data;
