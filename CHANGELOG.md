# dbt_lever_source v0.8.0

[PR #33](https://github.com/fivetran/dbt_lever_source/pull/33) includes the following updates:

## Breaking Change for dbt Core < 1.9.6

> *Note: This is not relevant to Fivetran Quickstart users.*

Migrated `freshness` from a top-level source property to a source `config` in alignment with [recent updates](https://github.com/dbt-labs/dbt-core/issues/11506) from dbt Core. This will resolve the following deprecation warning that users running dbt >= 1.9.6 may have received:

```
[WARNING]: Deprecated functionality
Found `freshness` as a top-level property of `lever` in file
`models/src_lever.yml`. The `freshness` top-level property should be moved
into the `config` of `lever`.
```

**IMPORTANT:** Users running dbt Core < 1.9.6 will not be able to utilize freshness tests in this release or any subsequent releases, as older versions of dbt will not recognize freshness as a source `config` and therefore not run the tests.

If you are using dbt Core < 1.9.6 and want to continue running Lever freshness tests, please elect **one** of the following options:
  1. (Recommended) Upgrade to dbt Core >= 1.9.6
  2. Do not upgrade your installed version of the `lever_source` package. Pin your dependency on v0.7.1 in your `packages.yml` file.
  3. Utilize a dbt [override](https://docs.getdbt.com/reference/resource-properties/overrides) to overwrite the package's `lever` source and apply freshness via the previous release top-level property route. This will require you to copy and paste the entirety of the previous release `src_lever.yml` file and add an `overrides: lever_source` property.

## Under the Hood
- Updates to ensure integration tests use latest version of dbt.

# dbt_lever_source v0.7.1

## Under the Hood
- Prepends `materialized` configs in the package's `dbt_project.yml` file with `+` to improve compatibility with the newer versions of dbt-core starting with v1.10.0. ([PR #30](https://github.com/fivetran/dbt_lever_source/pull/30))
- Updates the package maintainer pull request template. ([PR #31](https://github.com/fivetran/dbt_lever_source/pull/31))

## Documentation
- Corrected references to connectors and connections in the README. ([#29](https://github.com/fivetran/dbt_lever_source/pull/29))

## Contributors
- [@b-per](https://github.com/b-per) ([PR #30](https://github.com/fivetran/dbt_lever_source/pull/30))

# dbt_lever_source v0.7.0
[PR #26](https://github.com/fivetran/dbt_lever_source/pull/26) includes the following updates:

## Features
- For Fivetran Lever connectors created on or after July 27, 2024, the `USER` and `INTERVIEWER_USER` source tables have been renamed to `USERS` and `INTERVIEW_USER`, respectively. This package now prioritizes the `USERS` and `INTERVIEW_USER` tables if available, falling back to `USER` and `INTERVIEWER_USER` if not.
  - If you have both tables in your schema and would like to specify this package to leverage the `USER` and/or `INTERVIEWER_USER` tables, you can set the variables `lever__using_users` and/or `lever__using_interview_user` to false in your `dbt_project.yml`.
  - For more information, refer to the [July 2024 connector release notes](https://fivetran.com/docs/connectors/applications/lever/changelog#july2024) and the related [README section](https://github.com/fivetran/dbt_lever_source/blob/main/README.md##leveraging-legacy-connector-table-names).
- Introduced the ability to union source data from multiple Lever connectors. For more details, see the related [README section](https://github.com/fivetran/dbt_lever_source/blob/main/README.md#union-multiple-connectors).

## Bug fixes
- Fixed an issue where the dbt package would error due to a missing `CONTACT_LINK` source table for users without the titular source data, even if it was enabled in the Fivetran Connector. A null-filled table will now be generated in such cases.

## Under the hood
- Turned off freshness tests for `USER`/`USERS` and `INTERVIEW_USER`/`INTERVIEWER_USER` to avoid possible conflicts.
- Updated temporary models to union source data using the `fivetran_utils.union_data` macro.
- Added the `source_relation` column in each staging model to identify the origin of each field, utilizing the `fivetran_utils.source_relation` macro.
- Updated tests to include the new `source_relation` column.
- Added `not_null` tests for the relevant fields within each staging model.

# dbt_lever_source v0.6.0
## 🎉 Feature Update 🎉
- PostgreSQL and Databricks compatibility! ([#21](https://github.com/fivetran/dbt_lever_source/pull/21))

## 🚘 Under the Hood 🚘
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([#19](https://github.com/fivetran/dbt_lever_source/pull/19))
- Updated the pull request [templates](/.github). ([#19](https://github.com/fivetran/dbt_lever_source/pull/19))

# dbt_lever_source v0.5.0

## 🚨 Breaking Changes 🚨:
[PR #17](https://github.com/fivetran/dbt_lever_source/pull/17) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_lever_source v0.4.1
## Under the Hood
- Added column names in final staging model CTEs to follow best practices for model development.
# dbt_lever_source v0.4.0
## 🎉 Documentation and Feature Updates
- Updated README documentation updates for easier navigation and setup of the dbt package
- Included `lever_[source_table_name]_identifier` variable for additional flexibility within the package when source tables are named differently.

# dbt_lever_source v0.3.1
## Under the Hood
- Casted all staging model timestamp fields as `dbt_uitls.type_timestamp()` in order for downstream date functions to properly compile across warehouses. ([#11](https://github.com/fivetran/dbt_lever/pull/11))

# dbt_lever_source v0.3.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_fivetran_utils`. The latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_lever_source v0.1.0 -> v0.2.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!
