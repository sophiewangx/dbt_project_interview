{{
    config(
        materialized='incremental'
        ,unique_key = ['date_day', 'product_id']
    )
}}

with product_orders as (
  select 
    date(orders_joined.order_purchase_timestamp) as purchase_date
    ,orders_joined.product_id
  from  {{ ref('stg_order') }}  orders_joined 
)
, product_orders_joined as (
  select
    product_orders.purchase_date
    ,product_orders.product_id
    ,product.product_category_name
  from product_orders
  inner join {{ ref('stg_product') }} product on product.product_id = product_orders.product_id
)
, dim_date as (
    select * from {{ ref('dim_date') }}
)
, cross_join as (
  select 
    dim_date.date_day
    ,products.product_id
  from dim_date
  cross join {{ ref('stg_product')}} products

)
select 
    cross_join.date_day
    ,cross_join.product_id
    ,ifnull(count(product_orders_joined.product_id),0) as number_product_sold
from cross_join
left join product_orders_joined 
  on product_orders_joined.purchase_date = cross_join.date_day
  and product_orders_joined.product_id = cross_join.product_id
    {% if is_incremental() %}

    -- this filter will only be applied on an incremental run
    where date_day > (select max(date_day) from {{ this }})

    {% endif %}
group by  cross_join.date_day ,cross_join.product_id
