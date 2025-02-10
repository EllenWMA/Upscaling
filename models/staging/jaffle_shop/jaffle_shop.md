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

{% docs customer_idOrders %}
Customer ID for each customer. 
Therefore the same customer id can appear several time, if the customer have several orders. 
{% enddocs %}

{% docs customer_idCustomers %}
Customer ID for each customer.
One unique ID per row.  
Customer ID is primary key for customers. 
{% enddocs %}

{% docs order_date %}
Date for order. 
{% enddocs %}

{% docs first_name %}
First name of customer. 
{% enddocs %}

{% docs last_name %}
Last name of customer. 
{% enddocs %}


