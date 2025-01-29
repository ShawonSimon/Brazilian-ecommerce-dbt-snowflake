WITH all_dates AS (
    -- Combine all date columns to get complete date range
    SELECT order_purchase_timestamp::DATE as calendar_date
    FROM {{ ref('stg_orders') }}
    UNION DISTINCT
    SELECT order_approved_at::DATE
    FROM {{ ref('stg_orders') }}
    WHERE order_approved_at IS NOT NULL
    UNION DISTINCT
    SELECT order_delivered_carrier_date::DATE
    FROM {{ ref('stg_orders') }}
    WHERE order_delivered_carrier_date IS NOT NULL
    UNION DISTINCT
    SELECT order_delivered_customer_date::DATE
    FROM {{ ref('stg_orders') }}
    WHERE order_delivered_customer_date IS NOT NULL
    UNION DISTINCT
    SELECT order_estimated_delivery_date::DATE
    FROM {{ ref('stg_orders') }}
    WHERE order_estimated_delivery_date IS NOT NULL
),

calculated_dates AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY calendar_date) as date_key,
        calendar_date,
        EXTRACT(YEAR FROM calendar_date) as year,
        EXTRACT(QUARTER FROM calendar_date) as quarter,
        EXTRACT(MONTH FROM calendar_date) as month,
        EXTRACT(DAY FROM calendar_date) as day,
        EXTRACT(DOW FROM calendar_date) as day_of_week,
        EXTRACT(DOY FROM calendar_date) as day_of_year,
        -- Brazilian seasons
        CASE 
            WHEN EXTRACT(MONTH FROM calendar_date) IN (12,1,2) THEN 'Summer'
            WHEN EXTRACT(MONTH FROM calendar_date) IN (3,4,5) THEN 'Fall'
            WHEN EXTRACT(MONTH FROM calendar_date) IN (6,7,8) THEN 'Winter'
            ELSE 'Spring'
        END as season,
        -- Business day flag
        CASE 
            WHEN EXTRACT(DOW FROM calendar_date) IN (0, 6) THEN 0 
            ELSE 1 
        END as is_business_day
    FROM all_dates
)

SELECT
    date_key,
    calendar_date,
    year,
    quarter,
    month,
    day,
    day_of_week,
    day_of_year,
    CASE month
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END as month_name,
    CASE day_of_week
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END as day_name,
    season,
    is_business_day
FROM calculated_dates
ORDER BY calendar_date