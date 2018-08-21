CREATE SCHEMA IF NOT EXISTS cdm_crm;
DROP TABLE IF EXISTS member_structure_duration_order_store;

CREATE TABLE member_structure_duration_order_store (
  computing_until_month VARCHAR,
  computing_duration    INTEGER,
  order_id              INTEGER,
  order_fact_amount     DECIMAL(38, 2),
  order_deal_time       TIMESTAMP,
  member_no             VARCHAR,
  grade_id              INTEGER,
  grade_code            VARCHAR,
  channel_type          VARCHAR,
  sales_area            VARCHAR,
  store_region          VARCHAR
);
