-- use stg_strupe_payments model and sum amount of successful payments. 

with payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

successfull_payments_amount as (
    select  
        sum(payment_amount) as total_revenue
    from payments
    where payment_status = 'success'
) 

select * from successfull_payments_amount



Practice

Analyses


