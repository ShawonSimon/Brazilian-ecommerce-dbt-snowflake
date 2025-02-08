WITH OlistOrders AS (
    SELECT
     o.order_id AS order_id,
     o.customer_id AS customer_id,
     o.order_purchase_timestamp AS order_purchase_timestamp,
     o.order_approved_at AS order_approved_at,
     o.order_delivered_carrier_date AS order_delivered_carrier_date,
     o.order_delivered_customer_date AS order_delivered_customer_date,
     o.order_estimated_delivery_date AS order_estimated_delivery_date,
     o.order_status AS order_status,
     oi.product_id AS product_id,
     oi.seller_id AS seller_id,
     oi.price AS price,
     oi.freight_value AS freight_value,
     op.payment_sequential AS payment_sequential,
     op.payment_type AS payment_type,
     op.payment_installments AS payment_installments,
     op.payment_value AS payment_value,
     ROW_NUMBER() OVER (ORDER BY o.order_id) AS order_key
    FROM {{ ref('stg_orders') }} o
    LEFT JOIN {{ ref('stg_order_items') }} oi
     ON o.order_id = oi.order_id
    LEFT JOIN {{ ref('stg_order_payments') }} op
     ON o.order_id = op.order_id
)

SELECT
 order_key,
 order_id,
 customer_id,
 order_purchase_timestamp,
 order_approved_at,
 order_delivered_carrier_date,
 order_delivered_customer_date,
 order_estimated_delivery_date,
 order_status,
 product_id,
 seller_id,
 price,
 freight_value,
 payment_sequential,
 payment_type,
 payment_installments,
 payment_value
FROM OlistOrders
ORDER BY order_key