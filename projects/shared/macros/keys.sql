{% macro stable_hash(fields) %}
    md5(concat(
        {%- for field in fields -%}
            coalesce(cast({{ field }} as varchar), '__null__')
            {%- if not loop.last -%}, '||', {% endif -%}
        {%- endfor -%}
    ))
{% endmacro %}

