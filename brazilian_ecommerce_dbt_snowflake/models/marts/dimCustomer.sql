WITH dim_customer AS (
    SELECT
        ok.order_key,
        op.order_id,
        op.payment_sequential,
        op.payment_type,
        op.payment_installments,
        op.payment_value
    FROM {{ ref('stg_order_payments') }} op
    LEFT JOIN {{ ref('dim_order_keys') }} ok ON op.order_id = ok.order_id
)

SELECT
    order_key,
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM dim_customer