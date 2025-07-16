
# Lever Source dbt Package ([Docs](https://fivetran.github.io/dbt_lever_source/))

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_lever_source/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

## What does this dbt package do?
- Materializes [Lever staging tables](https://fivetran.github.io/dbt_lever_source/#!/overview/lever_source/models/?g_v=1) which leverage data in the format described by [this ERD](https://fivetran.com/docs/applications/lever/#schemainformation). These staging tables clean, test, and prepare your Lever data from [Fivetran's connector](https://fivetran.com/docs/applications/lever) for analysis by doing the following:
  - Name columns for consistency across all packages and for easier analysis
  - Adds freshness tests to source data  
      - dbt Core >= 1.9.6 is required to run freshness tests out of the box.
  - Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Generates a comprehensive data dictionary of your Lever data through the [dbt docs site](https://fivetran.github.io/dbt_lever_source/).
- These tables are designed to work simultaneously with our [Lever transformation package](https://github.com/fivetran/dbt_lever).

## How do I use the dbt package?
### Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran Lever connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

### Step 2: Install the package (skip if also using the `lever` transformation package)
If you  are **not** using the [Lever transformation package](https://github.com/fivetran/dbt_lever), include the following package version in your `packages.yml` file. If you are installing the transform package, the source package is automatically installed as a dependency.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/lever_source
    version: [">=0.8.0", "<0.9.0"]
```
### Step 3: Define database and schema variables
By default, this package runs using your destination and the `lever` schema. If this is not where your Lever data is (for example, if your Lever schema is named `lever_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    lever_database: your_destination_name
    lever_schema: your_schema_name 
```
### Step 4: Disable models for non-existent sources
Your Lever connection may not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Lever or have actively excluded some tables from your syncs. To disable the corresponding functionality in the package, you must set the relevant config variables to `false`. By default, all variables are set to `true`. Alter variables for only the tables you want to disable:

```yml
# dbt_project.yml
...
config-version: 2

vars:
    lever_using_requisitions: false # Disable if you do not have the requisition table, or if you do not want requisition related metrics reported
    lever_using_posting_tag: false # disable if you do not have (or want) the postings tag table
...
# (rest of file)
```

### (Optional) Step 5: Additional configurations
<details open><summary>Expand/collapse configurations</summary>

#### Change the build schema
By default, this package builds the Lever staging models within a schema titled (`<target_schema>` + `_stg_lever`) in your destination. If this is not where you would like your Lever staging data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    lever_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_lever_source/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    lever_<default_source_table_name>_identifier: your_table_name 
```

#### Passing Through Custom Columns
If you choose to include requisitions, the `REQUISITION` table may also have custom columns (all prefixed by `custom_field_`). To pass these columns through to the [final requisition model](https://github.com/fivetran/dbt_lever/blob/master/models/lever__requisition_enhanced.sql), add the following variable to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    lever_requisition_passthrough_columns: ['the', 'list', 'of', 'fields']
```

### Leveraging Legacy Connector Table Names
For Fivetran Lever connections created on or after July 27, 2024, the `USER` and `INTERVIEWER_USER` source tables have been renamed to `USERS` and `INTERVIEW_USER`, respectively. This package now prioritizes the `USERS` and `INTERVIEW_USER` tables if available, falling back to `USER` and `INTERVIEWER_USER` if not.

If you have both tables in your schema and would like to specify this package to leverage the `USER` and/or `INTERVIEWER_USER` tables, you can set the variables `lever__using_users` and/or `lever__using_interview_user` to false in your `dbt_project.yml`.
```yml
vars:
    lever__using_users: false # Default is true to use USERS. Set to false to use USER.
    lever__using_interview_user: false # Default is true to use INTERVIEW_USER. Set to false to use INTERVIEWER_USER.
```

### Union multiple connections
If you have multiple lever connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `lever_union_schemas` OR `lever_union_databases` variables (cannot do both) in your root `dbt_project.yml` file:

```yml
vars:
    lever_union_schemas: ['lever_1','lever_2'] # use this if the data is in different schemas/datasets of the same database/project
    lever_union_databases: ['lever_1','lever_2'] # use this if the data is in different databases/projects but uses the same schema name
```
Please be aware that the native `source.yml` connection set up in the package will not function when the union schema/database feature is utilized. Although the data will be correctly combined, you will not observe the sources linked to the package models in the Directed Acyclic Graph (DAG). This happens because the package includes only one defined `source.yml`.

To connect your multiple schema/database sources to the package models, follow the steps outlined in the [Union Data Defined Sources Configuration](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#union_data-source) section of the Fivetran Utils documentation for the union_data macro. This will ensure a proper configuration and correct visualization of connections in the DAG.

</details>

### (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand to view details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]
```

## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend that you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/lever_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_lever_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) to learn how to contribute to a dbt package.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_lever_source/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
