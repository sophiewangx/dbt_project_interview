with payments as (
  select
    order_id
    , ifnull(sum(payment_value),0) as total_payment_value
  from {{ source('ecommerce', 'payments') }} payment
  group by order_id
)
select * from payments