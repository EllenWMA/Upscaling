with

source as (
    select * from {{ source('jaffle_shop', 'customers') }} --from defined source
), 

transformed as (
    select 
        id as customer_id,
        first_name as customer_first_name, 
        last_name as customer_last_name, 
        first_name || ' '|| last_name as full_name
    from jaffle_shop
    --from source
)

select * from transformed
