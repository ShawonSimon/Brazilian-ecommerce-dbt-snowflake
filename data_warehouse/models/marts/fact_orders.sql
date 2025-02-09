WITH order_keys AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY ol.order_id) as order_key,
        ol.order_id
    FROM {{ ref('OlistOrders') }} ol
)

SELECT
    -- Foreign Keys to Dimensions
    ok.order_key,
    c.customer_key,
    s.seller_key,
    p.product_key,
    -- Date Keys
    d1.date_key as order_purchase_date_key,
    d2.date_key as order_approved_date_key,
    d3.date_key as order_delivered_carrier_date_key,
    d4.date_key as order_delivered_customer_date_key,
    d5.date_key as order_estimated_delivery_date_key,
    
    -- Order Details
    o.order_status,
    
    -- Payment Details
    o.payment_sequential,
    o.payment_installments,
    o.payment_value,
    op.payment_type_key,
    
    -- Order Item Metrics
    o.price,
    o.freight_value,
    
    -- Calculated Fields
    CASE 
        WHEN o.order_delivered_customer_date is not null 
        THEN DATEDIFF('day', o.order_purchase_timestamp, o.order_delivered_customer_date)
    END as delivery_time_days,
    CASE 
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date 
        THEN true 
        ELSE false 
    END as delivered_on_time,

FROM {{ ref('OlistOrders') }} o
    LEFT JOIN order_keys ok 
        ON o.order_id = ok.order_id
    LEFT JOIN {{ ref('dimCustomer') }} c 
        ON o.customer_id = c.customer_id
    LEFT JOIN {{ ref('dimSellers') }} s 
        ON o.seller_id = s.seller_id
    LEFT JOIN {{ ref('dimProduct') }} p
        ON o.product_id = p.product_id
    LEFT JOIN {{ ref('dimPaymentType') }} op 
        ON o.payment_type = op.payment_type_name
    -- Date dimension joins
    LEFT JOIN {{ ref('dimDate') }} d1 
        ON DATE(o.order_purchase_timestamp) = d1.calendar_date
    LEFT JOIN {{ ref('dimDate') }} d2 
        ON DATE(o.order_approved_at) = d2.calendar_date
    LEFT JOIN {{ ref('dimDate') }} d3 
        ON DATE(o.order_delivered_carrier_date) = d3.calendar_date
    LEFT JOIN {{ ref('dimDate') }} d4 
        ON DATE(o.order_delivered_customer_date) = d4.calendar_date
    LEFT JOIN {{ ref('dimDate') }} d5 
        ON DATE(o.order_estimated_delivery_date) = d5.calendar_date
ORDER BY ok.order_key