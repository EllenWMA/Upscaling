--this is a singular test, that tests if payments are positive. 
--The way it works is by finding those that are negative, and returning those if they exist.
--If the test does not fail, then all is non-negative. 

with payments as( 
    select * from {{ ref("stg_stripe_payments") }}
)

select 
    order_id, 
    sum(amount) as total_amount
from 
    payments
group by
    order_id
having total_amount < 0