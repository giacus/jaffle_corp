select *
from {{ ref('fct_experiment_outcomes') }}
where order_count_7d < 0
    or completed_order_count_7d < 0
    or net_revenue_usd_7d < -0.01

