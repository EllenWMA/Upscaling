
-- Add a where clause to the original SQL to test for uniqueness only on columns not equal to 00000 or 11111.  

{% test unique(model, column_name) %}
    select {{ column_name }}
    from {{ model }}
    where {{ column_name }} != '00000'
        and {{ column_name }} != '11111'
    group by {{ column_name }}
    having count(*) > 1
{% endtest %}


