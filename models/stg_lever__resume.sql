
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
        
    from base
),

final as (
    
    select 
        id, 
        _fivetran_synced,
        created_at,
        file_download_url,
        file_ext as file_extension,
        file_name,
        file_uploaded_at,
        opportunity_id

    from fields
)

select * from final
