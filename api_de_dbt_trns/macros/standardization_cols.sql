{% macro clean_phone_number(phone_column) %}
    -- Remove all non-numeric characters except for the extension marker 'x'
    WITH cleaned_phone AS (
        SELECT
            {{ phone_column }} AS original_phone,
            REGEXP_EXTRACT(REGEXP_REPLACE({{ phone_column }}, r'[^0-9x]', ''), r'([0-9]+x?[0-9]*)') AS numeric_phone -- Cleaned main number with optional extension
        )
    
    -- Extract the main phone number and the extension (if present)
    SELECT
        original_phone,
        REGEXP_EXTRACT(numeric_phone, r'^([0-9]+)') AS main_phone,   -- Extracts main phone number
        REGEXP_EXTRACT(numeric_phone, r'x([0-9]+)$') AS extension    -- Extracts extension (if any)
    FROM cleaned_phone
{% endmacro %}

{% macro clean_email(email_column) %}
    -- Convert email to lowercase and trim leading/trailing spaces
    LOWER(TRIM({{ email_column }}))
{% endmacro %}

{% macro mask_credit_card(cc_column) %}
    -- Mask the credit card number, showing only the last 4 digits
    CONCAT(REPEAT('X', LENGTH({{ cc_column }}) - 4), SUBSTR({{ cc_column }}, -4))
{% endmacro %}