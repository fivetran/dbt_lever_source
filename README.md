# Lever Source

This package models Lever data from [Fivetran's opportunity-endpoint Lever connector](https://fivetran.com/docs/applications/lever). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/lever#schemainformation).

This package aims to help you understand trends in recruiting, interviewing, and hiring at your company, as well as empower recruiting stakeholders with all potentially relevant information about individual opportunities, interviews, and jobs. It achieves this by:
- Enriching the core opportunity, interview, job posting, and requisition tables with relevant pipeline data and metrics
- Integrating the interview table with individual feedback and information regarding the employees involved
- Calculating the velocity of opportunities through each pipeline stage, alongside major job and candidate-related attributes for segmented funnel analysis


## Compatibility (if needed)
> Please be aware the [dbt_lever](https://github.com/fivetran/dbt_lever) and [dbt_lever_source](https://github.com/fivetran/dbt_lever_source) packages will only work with the [Fivetran opportunity-endpoint lever schema](https://fivetran.com/docs/applications/connector/changelog). If your Lever connector was set up prior to this change or is otherwise still using the candidate-endpoint, you will need to fully resync or set up a new Lever connector in order for the Fivetran dbt Lever packages to work.

## Models
This package contains staging models, designed to work simultaneously with our [Lever modeling package](https://github.com/fivetran/dbt_lever_source).  The staging models:
* Remove any rows that are soft-deleted
* Name columns consistently across all packages:
    * Boolean fields are prefixed with `is_` or `has_`
    * Timestamps are appended with `_at`
    * ID primary keys are prefixed with the name of the table.  For example, a user table's ID column is renamed `user_id`.
    * Foreign keys include the table that they refer to. For example, a interview's interview user ID column is renamed `interviewer_user_id`.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

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
It's possible that your Lever connector does not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Lever or actively excluded some tables from your syncs. To disable the corresponding functionality in the package, you must add the relevant variables. By default, all variables are assumed to be `true`. Add variables for only the tables you would like to disable:  

```yml
# dbt_project.yml
...
config-version: 2

vars:
    lever_using_requisitions: false # Disable if you do not have the requisition table, or if you do not want requisition related metrics reported
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
Please create issues or open PRs against `master`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Database Support
This package has been tested on BigQuery, Snowflake and Redshift.
Coming soon -- compatibility with Spark!

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
