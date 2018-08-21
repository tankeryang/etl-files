CREATE SCHEMA IF NOT EXISTS cdm_crm;
DROP TABLE IF EXISTS member_structure_duration_member_recency;

CREATE TABLE member_structure_duration_member_recency (
  computing_until_month VARCHAR,
  computing_duration    INTEGER,
  member_no             VARCHAR,
  recency               BIGINT
);
