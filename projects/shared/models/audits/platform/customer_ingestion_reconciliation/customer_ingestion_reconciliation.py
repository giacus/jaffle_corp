def model(dbt, session):
    """Compare normalized customer consent with the landed raw extract."""
    dbt.config(materialized="table")

    staged = dbt.ref("stg_customers").set_alias("staged")
    raw_extract = dbt.source("platform_app", "raw_customers").set_alias("raw_extract")

    return staged.join(
        raw_extract,
        "staged.customer_id = cast(raw_extract.customer_id as varchar)",
        how="outer",
    ).project(
        """
        coalesce(staged.customer_id, cast(raw_extract.customer_id as varchar)) as customer_id,
        staged.marketing_consent as staged_marketing_consent,
        cast(raw_extract.marketing_consent as boolean) as raw_marketing_consent,
        staged.marketing_consent = cast(raw_extract.marketing_consent as boolean)
            as marketing_consent_matches,
        staged.updated_at_utc as staged_updated_at_utc,
        cast(raw_extract.updated_at_utc as timestamp) as raw_updated_at_utc,
        case
            when staged.customer_id is null then 'missing_from_staging'
            when raw_extract.customer_id is null then 'missing_from_raw_extract'
            when staged.marketing_consent is distinct from cast(raw_extract.marketing_consent as boolean)
                then 'consent_mismatch'
            else 'aligned'
        end as ingestion_status
        """
    )
