WITH customer_keys AS (
    SELECT 
        customer_id,
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS customer_key
    FROM {{ ref('OlistOrders') }}
),
select_customers AS (
    SELECT DISTINCT
        customer_keys.customer_key,
        c.customer_id,
        c.customer_city,
        c.customer_state,
        FIRST_VALUE(g.geolocation_lat) OVER (
            PARTITION BY c.customer_id
            ORDER BY c.customer_id
        ) AS geolocation_lat,
        FIRST_VALUE(g.geolocation_lng) OVER (
            PARTITION BY c.customer_id
            ORDER BY c.customer_id
        ) AS geolocation_lng
    FROM {{ ref('stg_customers') }} c
    LEFT JOIN customer_keys 
     ON c.customer_id = customer_keys.customer_id
    LEFT JOIN {{ ref('stg_geolocation') }} g 
     ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
)
SELECT *
FROM select_customers
ORDER BY customer_key ASC

