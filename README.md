[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 
# Lever Source [(docs)](https://pensive-murdock-e1bb8a.netlify.app/#!/overview)

This package models Lever data from [Fivetran's Opportunity endpoint connector](https://fivetran.com/docs/applications/lever). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/lever#schemainformation).
> NOTE: If your Lever connector was created [prior to July 2020](https://fivetran.com/docs/applications/lever/changelog) or still uses the Candidate endpoint, you must fully re-sync your connector or set up a new connector to use Fivetran's Lever dbt packages.

This package enriches your Fivetran data by doing the following:
- Adds descriptions to tables and columns that are synced using Fivetran
- Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Models staging tables, which will be used in our transform package

## Models
This package contains staging models, designed to work simultaneously with our [Lever modeling package](https://github.com/fivetran/dbt_lever).  The staging models:
* Remove any rows that are soft-deleted
* Name columns consistently across all packages:
    * Boolean fields are prefixed with `is_` or `has_`
    * Timestamps are appended with `_at`
    * ID primary keys are prefixed with the name of the table.  For example, a user table's ID column is renamed `user_id`.
    * Foreign keys include the table that they refer to. For example, a interview's interview user ID column is renamed `interviewer_user_id`.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/lever_source
    version: [">=0.3.0", "<0.4.0"]
```

## Configuration
By default, this package looks for your Lever data in the `lever` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Lever data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    lever_database: your_database_name
    lever_schema: your_schema_name 
```

### Disabling Models
Your Lever connector might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Lever or have actively excluded some tables from your syncs. To disable the corresponding functionality in the package, you must set the relevant config variables to `false`. By default, all variables are set to `true`. Alter variables for only the tables you want to disable:

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

### Passing Through Custom Columns
If you choose to include requisitions, the `REQUISITION` table may also have custom columns (all prefixed by `custom_field_`). To pass these columns through to the [final requisition model](https://github.com/fivetran/dbt_lever/blob/master/models/lever__requisition_enhanced.sql), add the following variable to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    lever_requisition_passthrough_columns: ['the', 'list', 'of', 'fields']
```

## Contributions
Don't see a model or specific metric you would have liked to be included? Notice any bugs when installing 
and running the package? If so, we highly encourage and welcome contributions to this package! 
Please create issues or open PRs against `main`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Database Support
This package has been tested on BigQuery, Snowflake and Redshift.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [here](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate dbt transformations with Fivetran [here](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
