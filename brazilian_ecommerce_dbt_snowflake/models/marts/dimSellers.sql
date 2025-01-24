SELECT
    dim_seller_keys.seller_key,
    dim_seller_keys.seller_id,
    stg_sellers.seller_city,
    stg_sellers.seller_state,
    stg_order_items.order_id
FROM {{ ref('dim_seller_keys') }}
LEFT JOIN {{ ref('stg_sellers') }} ON
    dim_seller_keys.seller_id = stg_sellers.seller_id
LEFT JOIN {{ ref('stg_order_items') }} ON
    dim_seller_keys.seller_id = stg_order_items.seller_id
ORDER BY dim_seller_keys.seller_key
