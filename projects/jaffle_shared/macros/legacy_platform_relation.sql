{% macro legacy_platform_relation(model_name) %}
    {#
      Preserve real ref lineage whenever jaffle_shared is imported. The direct
      relation fallback only makes this foundation package independently
      parseable and lintable, where jaffle_platform is intentionally absent.
    #}
    {% if project_name == 'jaffle_shared' %}
        {{ return(api.Relation.create(
            database=target.database,
            schema=target.schema ~ '_mart',
            identifier=model_name
        )) }}
    {% else %}
        {{ return(ref('jaffle_platform', model_name)) }}
    {% endif %}
{% endmacro %}
