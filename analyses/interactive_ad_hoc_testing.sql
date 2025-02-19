

--This should find customers with more than one order. However due to final in customers, 
--the model only return unique customers(and their number of orders)
--select 
--    customer_id 
--from {{ ref('customers') }}
--group by customer_id
--having count(*) > 1

--We therefore use the following to find the customers with more than one order

select 
    customer_id
from {{ ref('customers') }}
where number_of_orders > 1


