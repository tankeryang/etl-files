CREATE SCHEMA IF NOT EXISTS dwd_crm;


DROP TABLE IF EXISTS dwd_crm.order_coupon_info;


CREATE TABLE dwd_crm.order_coupon_info (
    outer_order_no                   VARCHAR,
    coupon_no_array                  ARRAY<VARCHAR>,
    coupon_category                  VARCHAR,
    order_fact_amount_with_coupon    DECIMAL(18, 2),
    order_deal_time                  TIMESTAMP,
    order_deal_date                  DATE,
    order_deal_year_month            VARCHAR,
    order_deal_year                  INTEGER,
    order_deal_month                 INTEGER,
    create_time                      TIMESTAMP
) WITH (format = 'ORC');
