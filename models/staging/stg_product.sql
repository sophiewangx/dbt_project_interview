with product as (
  select
    product_id
    , product_category_name
    , product_length_cm
    , product_height_cm
    , product_width_cm
    , ifnull((product_length_cm*product_height_cm*product_width_cm),0) as volume_cubic_cm
    from {{ source('ecommerce', 'products') }} products
)
select * from product