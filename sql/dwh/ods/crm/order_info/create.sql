CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.order_info;


CREATE TABLE ods_crm.order_info (
    order_id              INTEGER,
    outer_order_no        VARCHAR,
    order_from            VARCHAR,
    store_code            VARCHAR,
    order_deal_time       TIMESTAMP,
    member_no             VARCHAR,
    order_grade           INTEGER,
    order_item_quantity   INTEGER,
    order_amount          DECIMAL(38, 2),
    order_fact_amount     DECIMAL(38, 2),
    order_status          VARCHAR,
    outer_return_order_no VARCHAR,
    create_time           TIMESTAMP
);
