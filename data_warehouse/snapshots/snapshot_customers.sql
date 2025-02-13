{% snapshot snapshot_customers %}

{{
    config(
      target_database='brazilian_db',
      target_schema='snapshots',
      unique_key='customer_key',
      strategy='Check',
      check_cols=['customer_city', 'customer_state'],
    )
}}

SELECT
    customer_key,
    customer_id,
    customer_city,
    customer_state
FROM {{ ref('dimCustomer') }}

{% endsnapshot %}