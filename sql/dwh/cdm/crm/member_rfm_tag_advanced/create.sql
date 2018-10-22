CREATE SCHEMA IF NOT EXISTS cdm_crm;
DROP TABLE IF EXISTS cdm_crm.member_rfm_tag_advanced;
--member_rfm_tag_advanced客户RFM高级选项表
CREATE TABLE cdm_crm.member_rfm_tag_advanced (
    computing_until_date      VARCHAR,
    computing_duration        INTEGER,
    brand_code                VARCHAR,
    member_no                 VARCHAR,
    average_order_amount      DECIMAL(38, 2),
    average_purchase_interval DECIMAL(38, 2),
    total_purchase_frequency  BIGINT,
    total_order_fact_amount   DECIMAL(38, 2),
    total_order_count         BIGINT,
    total_order_item_quantity BIGINT,
    total_return_frequency    BIGINT,
    total_return_amount       DECIMAL(38, 2),
    create_time               TIMESTAMP
);
