SELECT
    'computing_duration', array_join(ARRAY_AGG(duration), ',') from cdm_crm.rfm_duration;