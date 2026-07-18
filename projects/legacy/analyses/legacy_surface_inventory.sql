select
    'legacy_customer_360_v1' as legacy_model,
    count(*) as record_count
from {{ ref('legacy_customer_360', version=1) }}
union all
select
    'legacy_menu_mix_report_v2' as legacy_model,
    count(*) as record_count
from {{ ref('legacy_menu_mix_report_v2') }}
union all
select
    'legacy_refund_reason_bridge_v0' as legacy_model,
    count(*) as record_count
from {{ ref('legacy_refund_reason_bridge_v0') }}
