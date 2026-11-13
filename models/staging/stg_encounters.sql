select
    encounter_id,
    patient_id,
    encounter_date,
    lower(trim(encounter_type)) as encounter_type,
    total_charge
from {{ source('healthcare_raw', 'encounters') }}