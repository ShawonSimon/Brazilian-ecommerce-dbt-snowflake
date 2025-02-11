WITH seller_keys AS (
  SELECT DISTINCT
    o.seller_id AS seller_id,
    s.seller_city AS seller_city,
    s.seller_state AS seller_state,
    ROW_NUMBER() OVER (PARTITION BY o.seller_id ORDER BY o.seller_id) AS seller_key
  FROM {{ ref('OlistOrders') }} o
  LEFT JOIN {{ ref('stg_sellers') }} s
    ON o.seller_id = s.seller_id
)

SELECT
  ROW_NUMBER() OVER (ORDER BY seller_id) AS seller_key,
  seller_id,
  seller_city,
  seller_state
FROM seller_keys
WHERE seller_key = 1
ORDER BY seller_key