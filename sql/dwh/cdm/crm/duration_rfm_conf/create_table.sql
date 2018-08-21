CREATE SCHEMA IF NOT EXISTS cdm_crm;
DROP TABLE IF EXISTS duration_rfm_conf;

CREATE TABLE duration_rfm_conf (
  duration             INTEGER,
  type                 VARCHAR,
  rfm_conf_id          INTEGER,
  greater_than         INTEGER,
  not_greater_than     INTEGER,
  equals               VARCHAR,
  not_less_than        INTEGER,
  less_than            INTEGER,
  condition_expression VARCHAR
);
