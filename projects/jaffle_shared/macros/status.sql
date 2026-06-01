{% macro normalize_order_status(status_expr) %}
    case
        when lower({{ status_expr }}) in ('complete', 'completed', 'fulfilled', 'served') then 'completed'
        when lower({{ status_expr }}) in ('cancel', 'cancelled', 'void') then 'cancelled'
        when lower({{ status_expr }}) in ('refund', 'refunded', 'partially_refunded') then 'refunded'
        when lower({{ status_expr }}) in ('open', 'created', 'placed') then 'placed'
        else 'unknown'
    end
{% endmacro %}

{% macro normalize_payment_status(status_expr) %}
    case
        when lower({{ status_expr }}) in ('captured', 'settled', 'paid') then 'captured'
        when lower({{ status_expr }}) in ('authorized', 'auth') then 'authorized'
        when lower({{ status_expr }}) in ('failed', 'declined') then 'failed'
        when lower({{ status_expr }}) in ('refunded', 'reversed') then 'refunded'
        else 'unknown'
    end
{% endmacro %}

