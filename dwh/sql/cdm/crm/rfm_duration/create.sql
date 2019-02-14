CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.rfm_duration;


CREATE TABLE cdm_crm.rfm_duration (
    duration INTEGER
) WITH (format = 'ORC');
