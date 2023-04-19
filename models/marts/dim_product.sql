with product_orders as (
  select 
    orders_joined.product_id
    ,count(orders_joined.product_id) as total_units_sold
    ,sum(payments.total_payment_value) as total_revenue
  from  {{ ref('stg_order') }}  orders_joined 
  inner join {{ ref('stg_payment') }} payments on orders_joined.order_id = payments.order_id
  group by product_id
)
, product_order_final as (
  select
    product_orders.product_id
    ,total_units_sold
    ,case when row_number() over(order by total_units_sold desc) <= 10 then 1 else 0 end as top_10_product_flag
    ,total_revenue
   , product.volume_cubic_cm
  from product_orders
  left join {{ ref('stg_product')}} product on product.product_id = product_orders.product_id
)
select * from product_order_final