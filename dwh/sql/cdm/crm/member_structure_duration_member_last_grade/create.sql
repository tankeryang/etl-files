CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_structure_duration_member_last_grade;


CREATE TABLE cdm_crm.member_structure_duration_member_last_grade (
    computing_until_month VARCHAR,
    computing_duration    INTEGER,
    member_no             VARCHAR,
    current_grade_id      INTEGER,
    grade_name            VARCHAR,
    grade_code            VARCHAR,
    grade_change_time     TIMESTAMP
) WITH (format = 'ORC');
