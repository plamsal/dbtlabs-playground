# MCAP Healthcare dbt starter

This project transforms `MCAP_DEV.HEALTHCARE_RAW.PATIENTS` and `MCAP_DEV.HEALTHCARE_RAW.ENCOUNTERS` into staging views and a patient-summary mart.

## Project order

1. Sources: `healthcare_raw.patients` and `healthcare_raw.encounters` point to the existing Snowflake tables.
2. Staging: `stg_patients` standardizes patient names and demographics; `stg_encounters` standardizes encounter types. Both are views.
3. Mart: `fct_patient_summary` produces one row per patient with encounter counts, total charges, and most recent encounter date. It is a table.
4. Tests: `dbt build` runs selected models and their data tests in dependency order.

The model schema suffixes are `STAGING` and `MARTS`. dbt appends these to the target schema by default: a dev target schema of `DBT_PLAMSAL` produces `DBT_PLAMSAL_STAGING` and `DBT_PLAMSAL_MARTS`; a deployment target schema of `DBT_TEST` produces `DBT_TEST_STAGING` and `DBT_TEST_MARTS`.

## Configure dbt Cloud

1. Confirm both raw tables exist. The supplied sample setup creates `PATIENTS`; run the sample `ENCOUNTERS` setup SQL in Snowflake if that table is not there yet. Avoid re-running destructive `CREATE OR REPLACE` statements against data you need to keep.
2. In the dbt Cloud IDE, work on `feature/first-model` and sync this repository. Ensure the dbt development connection is connected to database `MCAP_DEV`, warehouse `COMPUTE_WH`, and your development target schema (for example `DBT_PLAMSAL`). Use a dbt-specific role with least privilege, not `ACCOUNTADMIN`.
3. Ensure the role can use the warehouse, read both raw tables, and create views/tables in the generated development schemas.
4. Compile the mart, then build all models and tests in dev:

	```text
	dbt compile --select fct_patient_summary
	dbt build
	```

5. In **Lineage**, inspect `PATIENTS` and `ENCOUNTERS` → the two `stg_*` models → `fct_patient_summary`. Verify the dev result in `DBT_PLAMSAL_MARTS.FCT_PATIENT_SUMMARY` (use your actual target schema if different).
6. Commit and sync the branch, open a pull request, and merge it into `main` after review.

## Deploy and orchestrate in dbt Cloud

Create a deployment environment named `Test` using the Snowflake connection and a target schema such as `DBT_TEST`. The role must be able to read the raw tables and create objects in `DBT_TEST_STAGING` and `DBT_TEST_MARTS`.

Create two deployment jobs against `main`:

1. `01_test_staging`: command `dbt build --select path:models/staging`. Schedule it or start it manually.
2. `02_test_marts`: command `dbt build --select path:models/marts`. Configure it to run after `01_test_staging` succeeds, if job chaining is available on your dbt Cloud plan. Otherwise schedule it after the first job and trigger it only once the staging run succeeds.

Run the first job and verify it succeeds before confirming the mart job starts. Results should land in `DBT_TEST_STAGING` and `DBT_TEST_MARTS`. In Snowflake, inspect `DBT_TEST_MARTS.FCT_PATIENT_SUMMARY`.

If the database, schema, or table names in Snowflake differ, update `models/sources.yml` before building. Do not commit Snowflake passwords, private keys, or other credentials to this repository.