{% docs store_ops__stg_store_shift_plans %}
Staging model for `stg_store_shift_plans` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_store_shift_plans__shift_plan_id %}
Source-system identifier for the shift plan.
{% enddocs %}

{% docs shared__stg_store_shift_plans__shift_date %}
Store-local calendar date of the planned shift.
{% enddocs %}

{% docs shared__stg_store_shift_plans__daypart %}
Named operating period, such as morning or evening, attached to the record.
{% enddocs %}

{% docs shared__stg_store_shift_plans__planned_minutes %}
Duration in minutes for planned.
{% enddocs %}

{% docs shared__stg_store_shift_plans__actual_minutes %}
Actual labor minutes recorded for the store shift.
{% enddocs %}

{% docs shared__stg_store_shift_plans__team_member_count %}
Count of team member recorded by the source.
{% enddocs %}

{% docs shared__stg_store_shift_plans__role_mix_code %}
Normalized code identifying role mix.
{% enddocs %}

{% docs shared__stg_store_shift_plans__source_version %}
Source version recorded on the store shift plans record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_store_shift_plans__actual_to_planned_minutes_ratio %}
Actual labor minutes divided by planned labor minutes for the shift.
{% enddocs %}

{% docs shared__stg_store_shift_plans__updated_at_utc %}
UTC timestamp when the source system last updated the `stg_store_shift_plans` record.
{% enddocs %}
