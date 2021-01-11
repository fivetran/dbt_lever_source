{% macro get_posting_tag_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "posting_id", "datatype": dbt_utils.type_string()}
] %}

{% if target.type == 'redshift' %}
 {{ columns.append( {"name": "tag", "datatype": dbt_utils.type_string(), "quote": True } ) }}
{% else %}
 {{ columns.append( {"name": "tag", "datatype": dbt_utils.type_string() } ) }}
{% endif %}

{{ return(columns) }}

{% endmacro %}
