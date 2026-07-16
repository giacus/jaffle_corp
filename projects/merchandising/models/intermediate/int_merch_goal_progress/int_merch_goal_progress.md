{% docs merchandising__int_merch_goal_progress %}
Intermediate model for `int_merch_goal_progress` transformation logic.
{% enddocs %}

{% docs merchandising__int_merch_goal_progress__menu_goal_progress_key %}
Deterministic surrogate key for the weekly menu target attainment fact by store and product family. Derived from goal identifier, store identifier, and product family.
{% enddocs %}

{% docs merchandising__int_merch_goal_progress__actual_units %}
The actual units value produced for each `int_merch_goal_progress` row.
{% enddocs %}

{% docs merchandising__int_merch_goal_progress__actual_item_revenue_usd %}
Actual item revenue for the weekly menu target attainment fact by store and product family, expressed in US dollars.
{% enddocs %}

{% docs merchandising__int_merch_goal_progress__estimated_actual_margin_usd %}
Estimated actual margin for the weekly menu target attainment fact by store and product family, expressed in US dollars. Derived from actual item revenue USD and average expected margin rate.
{% enddocs %}

{% docs merchandising__int_merch_goal_progress__unit_goal_attainment_rate %}
Unit goal attainment rate for the weekly menu target attainment fact by store and product family, expressed as a decimal ratio. Derived from target units and actual units.
{% enddocs %}

{% docs merchandising__int_merch_goal_progress__revenue_goal_attainment_rate %}
Revenue goal attainment rate for the weekly menu target attainment fact by store and product family, expressed as a decimal ratio. Derived from target net revenue USD and actual item revenue USD.
{% enddocs %}

{% docs merchandising__int_merch_goal_progress__unit_goal_status %}
Derived business classification for unit goal status on the weekly menu target attainment fact by store and product family. Derived from target units and actual units.
{% enddocs %}

{% docs merchandising__int_merch_goal_progress__average_expected_margin_rate %}
Average expected margin rate for the weekly menu target attainment fact by store and product family, expressed as a decimal ratio. Aggregated from expected recipe margin rate.
{% enddocs %}
