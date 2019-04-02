CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_last_feedback_time;


CREATE TABLE cdm_crm.member_last_feedback_time (
    member_no                         VARCHAR,
    brand_code                        VARCHAR,
    feedback_time                     TIMESTAMP,
    create_time                       TIMESTAMP
) WITH (format = 'ORC');
