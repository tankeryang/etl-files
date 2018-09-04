SELECT
    'computing_duration', array_join(ARRAY_AGG(duration), ',') from cdm_crm.member_structure_duration;