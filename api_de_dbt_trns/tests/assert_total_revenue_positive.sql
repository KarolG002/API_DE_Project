-- tests/assert_total_revenue_positive.sql
SELECT 
    SUM(monthly_revenue) as total_revenue
FROM {{ ref('ftc_financial_insights') }}
HAVING NOT(total_revenue > 0)