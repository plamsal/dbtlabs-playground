select
	patient_id,
	first_name,
	last_name,
	birth_date,
	upper(trim(gender)) as gender,
	upper(trim(state)) as state
from {{ source('healthcare_raw', 'patients') }}