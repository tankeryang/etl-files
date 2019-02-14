CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_structure_duration_order_store_last_grade_first_order_deal_time_recency_frequency;


CREATE TABLE cdm_crm.member_structure_duration_order_store_last_grade_first_order_deal_time_recency_frequency (
    computing_until_month        VARCHAR,
    computing_duration           INTEGER,
    channel_type                 VARCHAR,
    sales_area                   VARCHAR,
    store_region                 VARCHAR,
    grade_code                   VARCHAR,
    order_deal_time              TIMESTAMP,
    member_frist_order_deal_time TIMESTAMP,
    member_type                  VARCHAR,
    recency                      BIGINT,
    frequency                    BIGINT,
    order_fact_amount            DECIMAL(38, 2),
    order_id                     INTEGER,
    member_no                    VARCHAR
) WITH (format = 'ORC');

