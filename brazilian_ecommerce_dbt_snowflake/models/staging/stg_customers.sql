SELECT 
    * 
FROM 
    {{ source('brazilian_ecommerce', 'customers') }}