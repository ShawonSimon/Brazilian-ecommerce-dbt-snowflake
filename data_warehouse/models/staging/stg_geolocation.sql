SELECT 
    * 
FROM 
    {{ source('brazilian_ecommerce', 'geolocation') }}