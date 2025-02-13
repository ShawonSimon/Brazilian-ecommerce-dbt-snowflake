{% snapshot snapshot_customers %}

{{
    config(
      target_database='brazilian_db',
      target_schema='snapshots',
      unique_key='customer_key',
      strategy='timestamp',
      updated_at='updated_at',
    )
}}

SELECT
    customer_key,
    customer_id,
    customer_city,
    customer_state,
    updated_at
FROM {{ ref('dimCustomer') }}

{% endsnapshot %}