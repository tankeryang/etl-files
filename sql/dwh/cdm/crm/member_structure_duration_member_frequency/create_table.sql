CREATE SCHEMA IF NOT EXISTS cdm_crm;
DROP TABLE IF EXISTS member_structure_duration_member_frequency;

CREATE TABLE member_structure_duration_member_frequency (
  computing_until_month VARCHAR,
  computing_duration    INTEGER,
  member_no             VARCHAR,
  frequency             BIGINT
);