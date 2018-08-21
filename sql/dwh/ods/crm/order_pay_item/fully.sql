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


INSERT INTO order_pay_item
  SELECT
    pay_item_id,
    order_id,
    order_from,
    outer_order_no,
    pay_type,
    currency,
    pay_amount,
    coupon_no,
    localtimestamp
  FROM prod_mysql_crm.crm.order_pay_item
  WHERE
    date_format(create_time, '%Y-%m-%d %T') <= date_format(localtimestamp, '%Y-%m-%d %T');
