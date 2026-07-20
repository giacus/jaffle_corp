select
    'pinned_customer_migration_interface_v1' as legacy_model,
    count(*) as record_count
from {{ stable_customer_migration_relation() }}
union all
select
    'current_customer_migration_interface_v2' as legacy_model,
    count(*) as record_count
from {{ current_customer_migration_relation() }}
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
