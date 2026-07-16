with exposures as (
    select * from {{ ref('stg_experiment_exposures') }}
),

price_tests as (
    select * from {{ ref('stg_menu_price_tests') }}
)

select
    {{ shared.stable_hash(['exposures.experiment_id', 'exposures.variant_id']) }} as experiment_variant_key,
    exposures.experiment_id,
    exposures.variant_id,
    min(exposures.exposed_at_utc) as first_exposed_at_utc,
    max(exposures.exposed_at_utc) as most_recent_exposed_at_utc,
    cast(count(distinct exposures.exposure_id) as integer) as exposure_count,
    cast(count(distinct price_tests.price_test_id) as integer) as price_test_count,
    string_agg(distinct exposures.surface, ', ' order by exposures.surface) as surfaces
from exposures
left join price_tests
    on
        exposures.experiment_id = price_tests.experiment_id
        and exposures.variant_id = price_tests.variant_id
group by 1, 2, 3
