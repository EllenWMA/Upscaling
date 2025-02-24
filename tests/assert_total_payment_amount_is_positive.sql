
{{
    config(
        store_failures= true
    )
}}

--test that checks if the total amount for every row in the order model is positive
select 
    order_id, 
    sum(amount) as total_amount
from {{ ref('orders') }}
group by 1
having total_amount < 0

