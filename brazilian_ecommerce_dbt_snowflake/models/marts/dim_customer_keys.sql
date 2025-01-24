WITH customer_keys AS (
    SELECT
        customer_id,
        ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key
    FROM {{ ref('stg_customers') }}
)

SELECT
    customer_key,
    customer_id
FROM customer_keys