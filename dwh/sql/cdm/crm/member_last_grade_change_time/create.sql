CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_last_grade_change_time;


CREATE TABLE IF NOT EXISTS cdm_crm.member_last_grade_change_time (
    brand_code             VARCHAR,
    member_no              VARCHAR,
    last_grade_change_time TIMESTAMP
);
