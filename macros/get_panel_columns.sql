{% macro get_panel_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "canceled_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp() },
    {"name": "creator_id", "datatype": dbt_utils.type_string()},
    {"name": "end", "datatype": dbt_utils.type_timestamp(), "quote": True },
    {"name": "external_url", "datatype": dbt_utils.type_string()},
    {"name": "externally_managed", "datatype": "boolean"},
    {"name": "feedback_reminder", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string()},
    {"name": "note", "datatype": dbt_utils.type_string()},
    {"name": "stage_id", "datatype": dbt_utils.type_string()},
    
    {"name": "timezone", "datatype": dbt_utils.type_string()}
] %}

{% if target.type == 'snowflake' %}
 {{ columns.append( {"name": "START", "datatype": dbt_utils.type_timestamp(), "quote": True } ) }}
{% else %}
 {{ columns.append( {"name": "start", "datatype": dbt_utils.type_timestamp()} ) }}
{% endif %}

{{ return(columns) }}

{% endmacro %}
