{% test average_dollars_spent_greater_than_one(model, column_name, group_by_column) %}

    select 
        {{ group_by_column }},
        avg( {{ column_name }} ) as average_amount 
dbt ls --resource-type test    group by 1
    --group by {{ group_by_column}}
    having average_amount < 1

{% endtest %}



    







