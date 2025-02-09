WITH payment_types AS (
    SELECT DISTINCT
        payment_type
    FROM {{ ref('OlistOrders') }}
),

payment_types_with_key AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY payment_type) as payment_type_key,
        payment_type as payment_type_name
    FROM payment_types
)

SELECT
    payment_type_key,
    payment_type_name
FROM payment_types_with_key
WHERE payment_type_name IS NOT NULL
ORDER BY payment_type_key