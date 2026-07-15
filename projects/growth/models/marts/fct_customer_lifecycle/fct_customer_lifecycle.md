{% docs jaffle_growth__fct_customer_lifecycle %}
Public growth fact at one row per customer lifecycle state.
{% enddocs %}

{% docs growth__fct_customer_lifecycle__customer_lifecycle_key %}
Deterministic surrogate key for the growth fact at one row per customer lifecycle state. Derived from customer identifier and lifecycle stage.
{% enddocs %}

{% docs growth__fct_customer_lifecycle__days_to_first_order %}
Days to first order represented by the growth fact at one row per customer lifecycle state. Derived from first ordered at UTC and first seen at.
{% enddocs %}
