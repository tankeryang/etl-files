CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_last_order;


CREATE TABLE IF NOT EXISTS cdm_crm.member_last_order (
    member_no         VARCHAR,
    brand_code        VARCHAR,
    order_deal_time   TIMESTAMP
) WITH (format = 'ORC');
