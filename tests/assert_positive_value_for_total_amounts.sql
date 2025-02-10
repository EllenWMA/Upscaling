select
    order_id,
    sum(amount) as total_amount
from {{ ref('stg_stripe__payments') }}
group by 1,
having (total_amount < 0) --test if anyone have total amount below 0, since all should be >= 0.




