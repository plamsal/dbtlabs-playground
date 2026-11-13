select
	state,
	gender,
	count(*) as patient_count
from {{ ref('stg_patients') }}
group by
	state,
	gender