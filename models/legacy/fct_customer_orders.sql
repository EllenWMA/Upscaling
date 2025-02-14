with 

--Import CTEs

customers as (
    select * from {{ ref('stg_jaffle_shop__customers') }}
), 


orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
), 

payments as (
    select * from {{ ref('stg_stripe__payments') }}
), 

--Logical CTE


completed_payments as (
    select 
        order_id,
        max(payment_created_at) as payment_finalized_date, 
        sum(payment_amount) as total_amount_paid
    from payments
    where status <> 'fail'
    group by 1
),   


paid_orders as (
    select 
        orders.order_id,
        orders.customer_id,
        orders.order_placed_at,
        orders.order_status,
        completed_payments.total_amount_paid,
        completed_payments.payment_finalized_date,
        customers.customer_first_name,
        customers.customer_last_name
    from orders

    left join completed_payments on orders.order_id = completed_payments.order_id 
    left join customers on orders.customer_id = customers.customer_id
    ),


--Final CTE
final as (
    select
        order_id, 
        customer_id, 
        order_placed_at, 
        order_status, 
        total_amount_paid, 
        payment_finalized_date, 
        customer_first_name, 
        customer_last_name,   

        row_number() over (
            order by paid_orders.order_placed_at, paid_orders.order_id) 
            as transaction_seq, --Sales transaction sequence
        row_number() over (
            partition by paid_orders.customer_id 
            order by paid_orders.order_placed_at, paid_orders.order_id) --Customer sales sequence
            as customer_sales_seq, 

        case  --new vs returning customer
            when ( 
             rank() over (
                partition by paid_orders.customer_id
                order by paid_orders.order_placed_at, paid_orders.order_id
                ) = 1)
                then 'new'
        else 'return'
        end as nvsr, 
    
        sum(paid_orders.total_amount_paid) over (  --customer lifetime vlaue
            partition by paid_orders.customer_id 
            order by paid_orders.order_placed_at, paid_orders.order_id)
            as customer_lifetime_value, 

        first_value(paid_orders.order_placed_at) over ( --First day of sales
            partition by paid_orders.customer_id 
            order by paid_orders.order_placed_at, paid_orders.order_id )
            as fdos 
        
        from paid orders

        left join customers on paid_orders.customer_id = customers.customer_id
        ) 

--Simple Select Statement

select * from final
