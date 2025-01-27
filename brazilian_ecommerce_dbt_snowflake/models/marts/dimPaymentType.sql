WITH payment_types AS (
    SELECT DISTINCT
        payment_type
    FROM {{ ref('stg_order_payments') }}
),

payment_types_with_key AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY payment_type) as payment_type_key,
        payment_type as payment_type_name
    FROM payment_types
),

order_payments AS (
    SELECT 
        o.order_key,
        ptk.payment_type_key,
        ptk.payment_type_name
    FROM {{ ref('stg_order_payments') }} sop
    JOIN {{ ref('dim_order_keys') }} o
        ON sop.order_id = o.order_id
    JOIN payment_types_with_key ptk
        ON sop.payment_type = ptk.payment_type_name
)

SELECT
    order_key,
    payment_type_key,
    payment_type_name
FROM order_payments
ORDER BY order_key