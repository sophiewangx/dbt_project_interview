with fact_sales as (
  select 
    customer.customer_unique_id
    ,orders_joined.order_id
    ,orders_joined.order_purchase_timestamp
    ,orders_joined.order_estimated_delivery_date
    ,date_diff(date(orders_joined.order_estimated_delivery_date) , date( orders_joined.order_purchase_timestamp), DAY) as days_between_purchase_and_delivery_date
  from {{ ref('stg_order') }} orders_joined
  left join {{ ref('stg_customer') }} customer
    on customer.customer_id = orders_joined.customer_id
  group by customer_unique_id, order_id, order_purchase_timestamp, order_estimated_delivery_date

)select * from fact_sales