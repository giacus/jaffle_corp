select *
from {{ ref('fct_experiment_conversion') }}
where conversion_rate < 0 or conversion_rate > 1
