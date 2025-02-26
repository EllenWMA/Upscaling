with 

--Import CTEs

customers as (
    select * from {{ ref('stg_jaffle_shop__customers') }}
), 


paid_orders as( 
    select * from {{ ref('int_orders') }}
), 


--Final CTE
final as (
    select
        paid_orders.order_id, 
        paid_orders.customer_id, 
        paid_orders.order_placed_at, 
        paid_orders.order_status, 
        paid_orders.total_amount_paid, 
        paid_orders.payment_finalized_date, 
        customers.customer_first_name, 
        customers.customer_last_name, 

        row_number() over ( --Sales transaction sequence
            order by paid_orders.order_placed_at, paid_orders.order_id)
            as transaction_seq, 

        row_number() over ( --Customer sales sequence
            partition by paid_orders.customer_id
            order by paid_orders.order_placed_at, paid_orders.order_id) 
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
        
        from paid_orders

        left join customers on paid_orders.customer_id = customers.customer_id
        ) 

--Simple Select Statement

select * from final
