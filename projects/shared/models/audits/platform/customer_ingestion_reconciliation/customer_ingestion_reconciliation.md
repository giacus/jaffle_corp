{% docs shared__customer_ingestion_reconciliation %}
Customer-ingestion audit that compares normalized consent fields with the landed raw extract at customer grain.
{% enddocs %}

{% docs shared__customer_ingestion_reconciliation__staged_marketing_consent %}
Marketing-consent value produced by the normalized customer staging model.
{% enddocs %}

{% docs shared__customer_ingestion_reconciliation__raw_marketing_consent %}
Marketing-consent value read directly from the landed raw customer extract.
{% enddocs %}

{% docs shared__customer_ingestion_reconciliation__marketing_consent_matches %}
Whether normalized and raw marketing-consent values agree for the customer.
{% enddocs %}

{% docs shared__customer_ingestion_reconciliation__staged_updated_at_utc %}
Customer update timestamp produced by the normalized customer staging model.
{% enddocs %}

{% docs shared__customer_ingestion_reconciliation__raw_updated_at_utc %}
Customer update timestamp read directly from the landed raw customer extract.
{% enddocs %}

{% docs shared__customer_ingestion_reconciliation__ingestion_status %}
Reconciliation result that identifies aligned rows, missing rows, or consent differences.
{% enddocs %}
