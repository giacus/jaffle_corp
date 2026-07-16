{% docs planning__int_component_week_plan_actuals %}
Intermediate model for `int_component_week_plan_actuals` transformation logic.
{% enddocs %}

{% docs planning__int_component_week_plan_actuals__component_week_plan_variance_key %}
Deterministic surrogate key for the planned-versus-actual component usage fact at store-component-week-scenario grain. Derived from scenario name, component identifier, store identifier, and plan week start UTC.
{% enddocs %}

{% docs planning__int_component_week_plan_actuals__actual_received_quantity %}
Actual received quantity represented by the planned-versus-actual component usage fact at store-component-week-scenario grain.
{% enddocs %}

{% docs planning__int_component_week_plan_actuals__actual_used_quantity %}
Actual used quantity represented by the planned-versus-actual component usage fact at store-component-week-scenario grain.
{% enddocs %}

{% docs planning__int_component_week_plan_actuals__actual_waste_quantity %}
Actual waste quantity represented by the planned-versus-actual component usage fact at store-component-week-scenario grain.
{% enddocs %}

{% docs planning__int_component_week_plan_actuals__actual_received_cost_usd %}
Actual received cost for the planned-versus-actual component usage fact at store-component-week-scenario grain, expressed in US dollars.
{% enddocs %}

{% docs planning__int_component_week_plan_actuals__usage_quantity_variance %}
Usage quantity variance represented by the planned-versus-actual component usage fact at store-component-week-scenario grain. Derived from planned usage quantity and actual used quantity.
{% enddocs %}

{% docs planning__int_component_week_plan_actuals__usage_variance_status %}
Derived business classification for usage variance status on the planned-versus-actual component usage fact at store-component-week-scenario grain. Derived from planned usage quantity and actual used quantity.
{% enddocs %}
