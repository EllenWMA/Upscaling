
{{ config(enabled = false) }}

{% test average_dollars_spent_greater_than_one_disabled(model, column_name, group_by_column) %} --> changed name to disabled

    select 
        {{ group_by_column }},
        avg( {{ column_name }} ) as average_amount 
    from {{ model }}
    group by 1
    having average_amount < 1

{% endtest %}








