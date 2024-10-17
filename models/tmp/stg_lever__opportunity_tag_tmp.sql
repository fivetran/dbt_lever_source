ADD source_relation WHERE NEEDED + CHECK JOINS AND WINDOW FUNCTIONS! (Delete this line when done.)

{{
    fivetran_utils.union_data(
        table_identifier='opportunity_tag', 
        database_variable='lever_database', 
        schema_variable='lever_schema', 
        default_database=target.database,
        default_schema='lever',
        default_variable='opportunity_tag',
        union_schema_variable='lever_union_schemas',
        union_database_variable='lever_union_databases'
    )
}}