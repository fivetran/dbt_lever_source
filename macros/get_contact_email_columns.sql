{% macro get_contact_email_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "contact_id", "datatype": dbt_utils.type_string()},
    {"name": "email", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
