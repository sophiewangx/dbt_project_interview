with order_items as (
    select
        order_id
        , product_id
        , price
        , freight_value
        , order_item_id
        , row_number() over(partition by order_id order by order_item_id desc) as rownumber --assumption that latest order_item_id is latest price
    from  {{ source('ecommerce', 'order_items') }} order_items
)
, final_order_item as (
    select
        order_id
        ,product_id
        ,price
        ,freight_value
        ,(price+freight_value) as total_value 
    from order_items
    where rownumber = 1
)
select * from final_order_item