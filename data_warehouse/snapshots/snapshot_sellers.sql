{% snapshot snapshot_sellers %}

{{
    config(
      target_database='brazilian_db',
      target_schema='snapshots',
      unique_key='seller_id',
      strategy='timestamp',
      updated_at='updated_at',
    )
}}

SELECT
    seller_key,
    seller_id,
    seller_city,
    seller_state,
    updated_at
FROM {{ ref('dimSellers') }}

{% endsnapshot %}