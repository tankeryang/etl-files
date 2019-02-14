CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.rfm_duration_dimension_map;


CREATE TABLE cdm_crm.rfm_duration_dimension_map (
    duration               INTEGER,
    horizontal             VARCHAR,
    vertical               VARCHAR,
    h_id                   INTEGER,
    v_id                   INTEGER,
    h_greater_than         INTEGER,
    h_not_greater_than     INTEGER,
    h_equals               VARCHAR,
    h_not_less_than        INTEGER,
    h_less_than            INTEGER,
    h_condition_expression VARCHAR,
    v_condition_expression VARCHAR,
    v_greater_than         INTEGER,
    v_not_greater_than     INTEGER,
    v_equals               VARCHAR,
    v_not_less_than        INTEGER,
    v_less_than            INTEGER
) WITH (format = 'ORC');
