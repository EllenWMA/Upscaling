--Singular test changed to generic test 

--select 
--    customer_id, 
--    avg(amount) as average_amount
--from {{ ref('orders') }}
--group by 1
--having count(customer_id) > 1 and average_amount < 1

{{ config(enabled = false) }}

{% test average_dollars_spent_greater_than_one(model, group_by_column, column_name) %}
    select 
        {{ group_by_column }},
        avg( {{ column_name }} ) as average_amount
    from {{model}}
    group by 1
    having count(group_by_column) > 1 and average_amount < 1

{% endtest %}






    