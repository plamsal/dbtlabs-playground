# MCAP Healthcare dbt starter

This project transforms `MCAP_DEV.HEALTHCARE_RAW.PATIENTS` into a cleaned staging view and a reporting table.

## Project order

1. Source: `healthcare_raw.patients` points to the existing Snowflake table.
2. Staging: `stg_patients` standardizes gender and state values and is materialized as a view.
3. Mart: `patients_by_state_gender` aggregates the staged rows and is materialized as a table.
4. Tests: `dbt build` runs the models in dependency order and then runs their data tests.

The model schema suffixes are `STAGING` and `MARTS`. With the dbt target schema set to `HEALTHCARE`, dbt's standard schema naming produces `HEALTHCARE_STAGING` and `HEALTHCARE_MARTS`.

## Configure dbt Cloud

1. Push this project to the Git branch connected to the dbt Cloud project, then refresh the IDE. If the IDE's **Initialize dbt project** button has not been used yet, do not initialize an additional template over these files.
2. In dbt Cloud, configure the Snowflake connection/environment with database `MCAP_DEV`, warehouse `COMPUTE_WH`, and target schema `HEALTHCARE`. Use a dbt-specific role with only the required access, rather than `ACCOUNTADMIN`.
3. Ensure that role can use the warehouse and read `MCAP_DEV.HEALTHCARE_RAW.PATIENTS`, and can create views/tables in the generated schemas `HEALTHCARE_STAGING` and `HEALTHCARE_MARTS`.
4. In the IDE command bar or terminal, run `dbt debug`, then `dbt build`.
5. In **Lineage**, inspect `PATIENTS` → `stg_patients` → `patients_by_state_gender`. In Snowflake, query `MCAP_DEV.HEALTHCARE_MARTS.PATIENTS_BY_STATE_GENDER` to see the result.

If the database, schema, or table names in Snowflake differ, update `models/sources.yml` before building. Do not commit Snowflake passwords, private keys, or other credentials to this repository.