{% macro normalize_event_type(event_expr) %}
    case
        when lower({{ event_expr }}) in ('received', 'created', 'opened') then 'received'
        when lower({{ event_expr }}) in ('prep_started', 'started') then 'prep_started'
        when lower({{ event_expr }}) in ('ready', 'completed') then 'ready'
        when lower({{ event_expr }}) in ('handed_off', 'served', 'closed') then 'served'
        else 'unknown'
    end
{% endmacro %}

{% macro normalize_ticket_issue(issue_expr) %}
    case
        when lower({{ issue_expr }}) in ('cold_food', 'late_pickup', 'missing_item', 'wrong_item') then lower({{ issue_expr }})
        when lower({{ issue_expr }}) in ('payment_question', 'account_help') then lower({{ issue_expr }})
        else 'other'
    end
{% endmacro %}

{% macro normalize_po_status(status_expr) %}
    case
        when lower({{ status_expr }}) in ('received', 'closed') then 'received'
        when lower({{ status_expr }}) in ('partial', 'partially_received') then 'partially_received'
        when lower({{ status_expr }}) in ('open', 'ordered') then 'open'
        when lower({{ status_expr }}) in ('cancelled', 'void') then 'cancelled'
        else 'unknown'
    end
{% endmacro %}

