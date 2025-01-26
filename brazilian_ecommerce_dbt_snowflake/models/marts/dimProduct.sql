WITH product_keys AS (
 SELECT 
   product_id,
   ROW_NUMBER() OVER (ORDER BY product_id) AS product_key
 FROM {{ ref('stg_products') }}
)
SELECT
    product_keys.product_key,
    stg_products.product_id, 
    stg_products.product_category_name
FROM product_keys
LEFT JOIN {{ ref('stg_products') }}
    ON product_keys.product_id = stg_products.product_id
ORDER BY product_keys.product_key
