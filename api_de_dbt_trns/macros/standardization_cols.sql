{% macro clean_phone_number(phone_column) %}
    CASE
        WHEN {{ phone_column }} IS NULL THEN NULL
        ELSE
            CONCAT(
                REGEXP_EXTRACT(REGEXP_REPLACE({{ phone_column }}, r'[^0-9x]', ''), r'^(\d{1,10})'),
                COALESCE(CONCAT('x', NULLIF(REGEXP_EXTRACT(REGEXP_REPLACE({{ phone_column }}, r'[^0-9x]', ''), r'x(\d+)$'), '')), '')
            )
    END
{% endmacro %}

{% macro clean_email(email_column) %}
    -- Convert email to lowercase and trim leading/trailing spaces
    LOWER(TRIM({{ email_column }}))
{% endmacro %}

{% macro mask_credit_card(cc_column) %}
    -- Mask the credit card number, showing only the last 4 digits
    CONCAT(REPEAT('X', LENGTH({{ cc_column }}) - 4), SUBSTR({{ cc_column }}, -4))
{% endmacro %}