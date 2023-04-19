with customer_order as (
  select 
    customer.customer_unique_id
    ,count(order_id) as number_of_orders
    ,ifnull(sum(total_value), 0) as total_order_value
    ,min(order_purchase_timestamp) as first_order_date
    ,max(order_purchase_timestamp) as most_recent_order_date
    ,ifnull(max(total_value),0) as most_expensive_order_value
  from {{ ref('stg_order') }} orders_joined
  left join {{ ref('stg_customer') }} customer
    on customer.customer_id = orders_joined.customer_id
  group by customer_unique_id

)
select * from customer_order