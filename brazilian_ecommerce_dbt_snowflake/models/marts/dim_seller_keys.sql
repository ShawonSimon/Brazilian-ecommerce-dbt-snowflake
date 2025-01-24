WITH seller_keys AS (
    SELECT
        seller_id,
        ROW_NUMBER() OVER (ORDER BY seller_id) AS seller_key
    FROM {{ ref('stg_sellers') }}
)

SELECT
    seller_key,
    seller_id
FROM seller_keys