{% docs supply__fct_supply_risk_daily %}
Public risk classification at store-component-day grain.
{% enddocs %}

{% docs supply__fct_supply_risk_daily__supply_risk_daily_key %}
Deterministic surrogate key for the risk classification at store-component-day grain. Derived from store identifier, component identifier, and balance date UTC.
{% enddocs %}

{% docs supply__fct_supply_risk_daily__supply_risk_status %}
Derived business classification for supply risk status on the risk classification at store-component-day grain. Derived from estimated closing quantity, expected used quantity, observed waste quantity, has count review, and related inputs.
{% enddocs %}

{% docs supply__fct_supply_risk_daily__has_supply_risk %}
Whether the risk classification at store-component-day grain has supply risk. Derived from has late receipt, has count review, observed waste quantity, expected used quantity, and related inputs.
{% enddocs %}
