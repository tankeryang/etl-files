CREATE SCHEMA IF NOT EXISTS cdm_crm;
DROP TABLE IF EXISTS member_structure_order_info;
--正价单、退换货并购买新商品等
CREATE TABLE member_structure_order_info (
  computing_until_month VARCHAR,
  computing_duration    INTEGER,
  order_id              INTEGER,
  outer_order_no        VARCHAR,
  store_code            VARCHAR,
  order_deal_time       TIMESTAMP,
  member_no             VARCHAR,
  order_grade           INTEGER,
  order_item_quantity   INTEGER,
  order_amount          DECIMAL(38, 2),
  order_fact_amount     DECIMAL(38, 2),
  order_status          VARCHAR,
  outer_return_order_no VARCHAR
);