{{
    fivetran_utils.union_data(
        table_identifier='posting_interview', 
        database_variable='lever_database', 
        schema_variable='lever_schema', 
        default_database=target.database,
        default_schema='lever',
        default_variable='posting_interview',
        union_schema_variable='lever_union_schemas',
        union_database_variable='lever_union_databases'
    )
}}