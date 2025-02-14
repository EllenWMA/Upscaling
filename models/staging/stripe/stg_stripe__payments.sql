with 

source as (
    select * from {{ source('stripe', 'payment') }}
), 

transformed as (
    select 
        id as payment_id, 
        orderid as order_id, 
        paymentmethod as payment_method, 
        status as payment_status, 
        round(amount / 100.0, 2) as payment_amount, --amount is stored inc ents, convert it to dollars, and round with 2 decimals
        created as payment_created_at
    from stripe
)

select * from transformed


