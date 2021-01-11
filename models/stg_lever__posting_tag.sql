
with base as (

    select * 
    from {{ ref('stg_lever__posting_tag_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_lever__posting_tag_tmp')),
                staging_columns=get_posting_tag_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        posting_id,
        {% if target.type == 'redshift' %}
        "tag"
        {% else %} tag {% endif %}
        as tag_name,
        _fivetran_synced

    from fields
    where not coalesce("_FIVETRAN_DELETED", false)
)

select * from final
