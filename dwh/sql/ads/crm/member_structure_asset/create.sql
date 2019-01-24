CREATE SCHEMA IF NOT EXISTS ads_crm;
DROP TABLE IF EXISTS ads_crm.member_structure_asset;

CREATE TABLE ads_crm.member_structure_asset (
    computing_until_month        VARCHAR,
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
    create_time                  TIMESTAMP
) WITH partition_by (partitioned_by = array['vchr_computing_until_month']);
