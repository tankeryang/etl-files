SELECT
    ARRAY_AGG(duration) AS computing_duration,
    ARRAY['2018-10-01'] AS c_date    
FROM cdm_crm.member_structure_duration;