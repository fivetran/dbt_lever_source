{{
    fivetran_utils.union_data(
        table_identifier='interviewer_user', 
        database_variable='lever_database', 
        schema_variable='lever_schema', 
        default_database=target.database,
        default_schema='lever',
        default_variable='interviewer_user',
        union_schema_variable='lever_union_schemas',
        union_database_variable='lever_union_databases'
    )
}}