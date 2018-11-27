CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.member_grade_log;


CREATE TABLE ods_crm.member_grade_log (
    log_id             INTEGER,
    member_no          VARCHAR,
    brand_code         VARCHAR,
    before_grade_id    INTEGER,
    current_grade_id   INTEGER,
    grade_change_time  TIMESTAMP,
    create_time        TIMESTAMP
);
