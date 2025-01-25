WITH seller_keys AS (
  SELECT
    stg_sellers.seller_id,
    ROW_NUMBER() OVER (ORDER BY stg_sellers.seller_id) AS seller_key
  FROM {{ ref('stg_sellers') }}
)
SELECT
  seller_keys.seller_key,
  stg_sellers.seller_id,
  stg_sellers.seller_city,
  stg_sellers.seller_state,
  ARRAY_AGG(stg_order_items.order_id) AS order_ids
FROM {{ ref('stg_sellers') }}
LEFT JOIN seller_keys
  ON stg_sellers.seller_id = seller_keys.seller_id
LEFT JOIN {{ ref('stg_order_items') }}
  ON stg_sellers.seller_id = stg_order_items.seller_id
GROUP BY
  seller_keys.seller_key,
  stg_sellers.seller_id,
  stg_sellers.seller_city,
  stg_sellers.seller_state
ORDER BY
  seller_keys.seller_key