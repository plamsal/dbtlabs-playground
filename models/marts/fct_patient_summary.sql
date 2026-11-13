select
    p.patient_id,
    p.full_name,
    p.age,
    p.state,
    count(e.encounter_id) as total_encounters,
    coalesce(sum(e.total_charge), 0) as total_charges,
    max(e.encounter_date) as last_visit_date
from {{ ref('stg_patients') }} as p
left join {{ ref('stg_encounters') }} as e
    on p.patient_id = e.patient_id
group by
    p.patient_id,
    p.full_name,
    p.age,
    p.state