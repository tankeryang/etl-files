DELETE FROM cdm_crm.rfm_duration;


INSERT INTO cdm_crm.rfm_duration (
    duration
    )
    SELECT
        1 AS duration
    UNION ALL
    SELECT
        2 AS duration;
