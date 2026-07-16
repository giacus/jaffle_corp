{% docs planning__fct_planning_exception_daily %}
Public daily planning exception fact by scenario and exception family.
{% enddocs %}

{% docs planning__fct_planning_exception_daily__planning_exception_daily_key %}
Deterministic surrogate key for the daily planning exception fact by scenario and exception family. Derived from store identifier, exception date UTC, scenario name, and exception family.
{% enddocs %}

{% docs planning__fct_planning_exception_daily__exception_count %}
Number of exceptions represented by the daily planning exception fact by scenario and exception family.
{% enddocs %}

{% docs planning__fct_planning_exception_daily__exception_status %}
Derived business classification for exception status on the daily planning exception fact by scenario and exception family. Derived from exception count.
{% enddocs %}
