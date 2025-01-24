WITH product_keys AS (
    SELECT
        product_id,
        ROW_NUMBER() OVER (ORDER BY product_id) AS product_key
    FROM {{ ref('stg_products') }}
)

SELECT
    product_key,
    product_id
FROM product_keys