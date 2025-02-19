with base as (

    select * 
    from {{ ref('stg_lever__contact_phone_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_lever__contact_phone_tmp')),
                staging_columns=get_contact_phone_columns()
            )
        }}

        {{ fivetran_utils.source_relation(
            union_schema_variable='lever_union_schemas', 
            union_database_variable='lever_union_databases') 
        }}

    from base
),

final as (

    select
        source_relation, 
        contact_id,
        index,
        type as phone_type,
        value as phone_number,
        cast(_fivetran_synced as {{ dbt.type_timestamp() }}) as _fivetran_synced
    from fields
)

select * 
from final
