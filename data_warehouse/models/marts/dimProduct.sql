WITH product_keys AS (
    SELECT DISTINCT
        o.product_id,
        p.product_category_name,
        ROW_NUMBER() OVER (PARTITION BY o.product_id ORDER BY o.product_id) AS rn
    FROM {{ ref('OlistOrders') }} o
    LEFT JOIN {{ ref('stg_products') }} p
        ON o.product_id = p.product_id
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY product_id) AS product_key,
    product_id,
    product_category_name
FROM product_keys
WHERE rn = 1
ORDER BY product_key