{{
    fivetran_utils.union_data(
        table_identifier='interviewer_user', 
        database_variable='lever_database', 
        schema_variable='interview_user' if var('lever__using_interview_user', lever_source.does_table_exist('interview_user')) else 'interviewer_user', 
        default_database=target.database,
        default_schema='lever',
        default_variable='interview_user' if var('lever__using_interview_user', lever_source.does_table_exist('interview_user')) else 'interviewer_user',
        union_schema_variable='lever_union_schemas',
        union_database_variable='lever_union_databases'
    )
}}