CREATE SCHEMA IF NOT EXISTS cdm_crm;
DROP TABLE IF EXISTS member_structure_asset;
--member_structure_all全体客户结构分析统计表
CREATE TABLE member_structure_asset (
  computing_until_month   VARCHAR,
  computing_duration      INTEGER,
  channel_type            VARCHAR,
  sales_area              VARCHAR,
  store_region            VARCHAR,
  purchase_type           VARCHAR,
  vip_type                VARCHAR,
  reg_source              VARCHAR,
  grade_code              VARCHAR,
  member_type             VARCHAR,
  recency                 BIGINT,
  --   #   average_purchase_time TIMESTAMP,
  --   #   average_order_amount DECIMAL (38, 2
  -- ),
  --   #   average_purchase_interval INTEGER,
  --   total_purchase_frequency INTEGER,
  total_order_fact_amount DECIMAL(38, 2),
  total_order_count       BIGINT,
  total_member_count      BIGINT,
  --   #   totaL_order_item_quantity BIGINT,
  --   #   total_return_frequency INTEGER,
  --   #   total_return_amount DECIMAL (38, 2
  -- ),
  create_time             TIMESTAMP
);
