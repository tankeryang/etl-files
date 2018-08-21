CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.order_item;


CREATE TABLE ods_crm.order_item (
  order_item_no      VARCHAR,
  order_from         INTEGER,
  order_id           INTEGER,
  outer_order_no     VARCHAR,
  clerk_no           VARCHAR,
  item_type          VARCHAR,
  original_order_id  INTEGER,
  product_item_code  VARCHAR,
  product_code       VARCHAR,
  product_color_code VARCHAR,
  product_size_code  VARCHAR,
  quantity           INTEGER,
  total_amount       DECIMAL(38, 2),
  fact_amount        DECIMAL(38, 2),
  discount_rate      DECIMAL(38, 2),
  currency           VARCHAR,
  discount_type      VARCHAR,
  item_status        VARCHAR,
  return_quantity    INTEGER,
  return_amount      DECIMAL(38, 2),
  sub_coupon_amount  DECIMAL(38, 2),
  create_time        TIMESTAMP
);
