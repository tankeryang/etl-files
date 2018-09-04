CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_first_order;


CREATE TABLE cdm_crm.member_first_order (
    member_no     VARCHAR,
    order_deal_time TIMESTAMP
);
