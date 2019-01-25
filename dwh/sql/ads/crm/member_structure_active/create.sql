CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_structure_active;


CREATE TABLE ads_crm.member_structure_active (
    computing_until_month               VARCHAR,
    computing_duration                  INTEGER,
    channel_type                        VARCHAR,
    sales_area                          VARCHAR,
    store_region                        VARCHAR,
    member_type                         VARCHAR,
    frequency_type                      VARCHAR,
    recency_type                        VARCHAR,
    total_member_count                  BIGINT,
    member_count_percentage             DECIMAL(38, 4),
    total_order_fact_amount             DECIMAL(38, 2),
    monetary_per_member                 DECIMAL(38, 2),
    total_repurchased_member_count      BIGINT,
    total_repurchased_order_fact_amount DECIMAL(38, 2),
    total_repurchased_percentage        DECIMAL(38, 4),
    member_existing_percentage          DECIMAL(38, 4),
    create_time                         TIMESTAMP,
    vchr_computing_until_month          VARCHAR
) WITH (partitioned_by = array['vchr_computing_until_month']);
