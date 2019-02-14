CREATE SCHEMA IF NOT EXISTS cdm_crm;
DROP TABLE IF EXISTS cdm_crm.member_structure_order_info_range;
--订单范围
CREATE TABLE cdm_crm.member_structure_order_info_range (
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
) WITH (format = 'ORC');