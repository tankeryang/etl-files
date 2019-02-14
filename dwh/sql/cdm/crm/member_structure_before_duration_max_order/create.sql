CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_structure_before_duration_max_order;

--本月、季度、半年、年等之前的最近一次购买
CREATE TABLE cdm_crm.member_structure_before_duration_max_order (
    computing_until_month VARCHAR,
    computing_duration    INTEGER,
    channel_type          VARCHAR,
    sales_area            VARCHAR,
    store_region          VARCHAR,
    member_no             VARCHAR,
    max_order_deal_time   TIMESTAMP
) WITH (format = 'ORC');