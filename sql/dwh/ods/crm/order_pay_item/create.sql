CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.order_pay_item;


CREATE TABLE ods_crm.order_pay_item (
  pay_item_id    INTEGER, -- primary key
  order_id       INTEGER,
  order_from     INTEGER,
  outer_order_no VARCHAR,
  pay_type       VARCHAR,
  currency       VARCHAR,
  pay_amount     DECIMAL(38, 2),
  coupon_no      VARCHAR,
  create_time    TIMESTAMP
);
