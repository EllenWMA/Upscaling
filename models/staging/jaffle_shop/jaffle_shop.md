{% docs order_status %}

One of the following values: 

| status         | definition                                       |
|----------------|--------------------------------------------------|
| placed         | Order placed, not yet shipped                    |
| shipped        | Order has been shipped, not yet delivered        |
| completed      | Order has been recieved by customers             |
| return pending | Customer indicated they want to return this item |
| returned       | Item has been returned                           |

{% enddocs %}

{% docs order_id %}
Order id is unique, so new ID for each order.
Order id is primary key for orders.
{% enddocs %}




  #orders: customer_id, order_date, status
  #customers: customer_id, first_name, last_name
  
