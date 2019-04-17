CREATE SCHEMA IF NOT EXISTS dwd_crm;


DROP TABLE IF EXISTS dwd_crm.member_first_order;


CREATE TABLE IF NOT EXISTS dwd_crm.member_first_order (
    member_no             VARCHAR,
    brand_code            VARCHAR,
    order_deal_time       TIMESTAMP,
    order_deal_date       DATE,
    order_deal_year_month VARCHAR,
    order_deal_year       INTEGER,
    order_deal_month      INTEGER
) WITH (format = 'ORC');
