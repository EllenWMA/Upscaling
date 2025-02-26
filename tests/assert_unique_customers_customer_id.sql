--test that check if every row in the customers model is unique

select
    customer_id
from {{ ref('customers') }}
group by 1
having count(*) > 1 --find customers with the same customer_id




--look at how the compiled results changed from the tests