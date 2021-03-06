CREATE SCHEMA IF NOT EXISTS ads_crm;
DROP TABLE IF EXISTS ads_crm.member_structure_asset;

CREATE TABLE ads_crm.member_structure_asset (
    computing_duration           INTEGER,
    channel_type                 VARCHAR,
    sales_area                   VARCHAR,
    store_region                 VARCHAR,
    purchase_type                VARCHAR,
    vip_type                     VARCHAR,
    reg_source                   VARCHAR,
    grade_code                   VARCHAR,
    member_type                  VARCHAR,
    recency_type                 VARCHAR,
    total_member_count           BIGINT,
    member_count_percentage      DECIMAL(38, 4),
    total_order_fact_amount      DECIMAL(38, 2),
    order_fact_amount_percentage DECIMAL(38, 4),
    total_order_count            BIGINT,
    create_time                  TIMESTAMP,
    computing_until_month        VARCHAR
) WITH (partitioned_by = array['computing_until_month'], format = 'ORC');
