with orders as (
    select
        orders.order_id
        , orders.customer_id
        , orders.order_purchase_timestamp
        , orders.order_status
        , orders.order_estimated_delivery_date
    from {{ source('ecommerce', 'orders') }} orders
)
, orders_joined as (
    select
        orders.order_id
        , orders.customer_id
        , order_items_cleaned.product_id
        , orders.order_purchase_timestamp
        , orders.order_status
        , orders.order_estimated_delivery_date
        , order_items_cleaned.price
        , order_items_cleaned.freight_value
        , order_items_cleaned.total_value
    from orders
    inner join {{ ref('stg_order_item') }} order_items_cleaned
    on orders.order_id = order_items_cleaned.order_id
)
select * from orders_joined