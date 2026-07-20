select *
from {{ ref('customer_ingestion_reconciliation') }}
where ingestion_status != 'aligned'
