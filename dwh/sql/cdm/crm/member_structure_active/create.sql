CREATE SCHEMA IF NOT EXISTS cdm_crm;
DROP TABLE IF EXISTS cdm_crm.member_structure_active;
--member_structure_active客户结构分析活跃客户表
CREATE TABLE member_structure_active (
    computing_until_month               VARCHAR,
    computing_duration                  INTEGER,
    channel_type                        VARCHAR,
    sales_area                          VARCHAR,
    store_region                        VARCHAR,
    member_type                         VARCHAR,
    frequency_type VARCHAR,
    recency_type VARCHAR,
    total_member_count                  BIGINT,
    total_order_fact_amount             DECIMAL(38, 2),
    monetary_per_member                 DECIMAL(38, 2),
    total_repurchased_member_count      BIGINT,
    total_repurchased_order_fact_amount DECIMAL(38, 2),
    total_repurchased_percentage        DECIMAL(38, 4),
    --total_order_count         BIGINT,
    create_time                         TIMESTAMP
) WITH (format = 'ORC');
