SELECT 
    * 
FROM 
    {{ source('brazilian_ecommerce', 'products') }}