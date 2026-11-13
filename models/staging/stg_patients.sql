select
	patient_id,
	initcap(first_name) || ' ' || initcap(last_name) as full_name,
	birth_date,
	datediff(year, birth_date, current_date)
		- iff(
			dateadd(year, datediff(year, birth_date, current_date), birth_date) > current_date,
			1,
			0
		) as age,
	upper(trim(gender)) as gender,
	upper(trim(state)) as state
from {{ source('healthcare_raw', 'patients') }}