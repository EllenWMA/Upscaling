select 
    orders.id as order_id,
    orders.user_id as customer_id, 
    last_name as surname,
    first_name as givenname,
    first_order_date, 
    order_count,
    total_lifetime_value,
    round(amount/100.0,2) as order_value_dollars,
    orders.status as order_status, 
    payments.status as payment_status, 
from raw.jaffle_shop.orders as orders 

join (
    select 
        first_name || ' ' || last_name as name, --concatenates first name and last name
        * --selects every other columns in the customer table
    from raw.jaffle_shop.customers
) customers --calls it customers
on orders.user_id = customers.id --joins on user_id(user_id in orders and id in customers) 


join (
    select 
        b.id as customer_id,
        b.name as full_name,
        b.last_name as surname,
        b.first_name as givenname, 
        min(order_date) as first_order_date,
        min(case when a.status NOT IN ('returned', 'return_pending') then order_date end) as first_non_returned_order_date, --if status is not returned or returned_pending, order_date is ...
        max(case when a.status NOT IN ('returned', 'return_pending') then order_date end) as most_recent_non_returned_order_date, 
        COALESCE(max(user_order_seq), 0) as order_count, 
        COALESCE(count(case when a.status != 'returned' then 1 end), 0) as non_returned_order_count, 
        sum(case when a.status NOT IN ('returned', 'return_pending') then ROUND(c.amount/100.0, 2) else 0 end) as total_lifetime_value,
        sum(case when a.status NOT IN ('returned', 'return_pending') then ROUND(c.amount/100.0, 2) else 0 end)/NULLIF(count(case when a.status NOT IN ('returned', 'return_pending') then 1 end), 0) as avg_non_returned_order_value,
        array_agg(distinct a.id) as order_ids
 

    from (
        select 
            row_number() over (partition by user_id order by order_date, id) as user_order_seq, 
            *
        from raw.jaffle_shop.orders
    ) a

    join (
        select 
            first_name || ' ' || last_name as name, 
            *
        from raw.jaffle_shop.customers
    ) b
    on a.user_id = b.id

    left outer join raw.stripe.payment c
    on a.id = c.orderid

    where a.status NOT IN ('pending') and c.status != 'fail'
    group by b.id, b.name, b.last_name, b.first_name

) customer_order_history
on orders.user_id = customer_order_history.customer_id 

left outer join raw.stripe.payment payments 
on orders.id = payments.orderid 

where payments.status != 'fail'
