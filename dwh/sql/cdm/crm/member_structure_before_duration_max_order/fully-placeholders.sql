SELECT
    ARRAY_AGG(duration) AS computing_duration,
    ARRAY[current_date] AS c_date
FROM cdm_crm.member_structure_duration;