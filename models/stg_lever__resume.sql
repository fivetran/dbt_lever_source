with base as (

    select * 
    from {{ ref('stg_lever__resume_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_lever__resume_tmp')),
                staging_columns=get_resume_columns()
            )
        }}

        {{ fivetran_utils.source_relation(
            union_schema_variable='lever_union_schemas', 
            union_database_variable='lever_union_databases') 
        }}

    from base
),

{# Figure out if the fields are Epoch or datetime timestamps #}
{%- set columns = adapter.get_columns_in_relation(ref('stg_lever__resume_tmp')) -%}
{%- set timestamp_fields = [] -%}
{%- for column in columns -%}
    {%- if column.name|lower in ['created_at', 'created_at_epoch'] -%}
        {%- do timestamp_fields.append({"name": column.name|lower, "is_epoch": column.is_integer()}) -%}
    {%- endif -%}
{%- endfor -%}

final as (

    select
        source_relation, 
        id, 
        cast(_fivetran_synced as {{ dbt.type_timestamp() }}) as _fivetran_synced,

        {%- for timestamp in timestamp_fields %}
            cast( {{ dbt_date.from_unixtimestamp(timestamp.name, "milliseconds") if timestamp.is_epoch else timestamp.name }} as {{ dbt.type_timestamp() }}) as {{ timestamp.name }},
        {%- endfor %}

        file_download_url,
        file_ext as file_extension,
        file_name,
        cast(file_uploaded_at as {{ dbt.type_timestamp() }}) as file_uploaded_at, -- would need to do the same for file_uploaded_at
        opportunity_id

    from fields
)

select *
from final
