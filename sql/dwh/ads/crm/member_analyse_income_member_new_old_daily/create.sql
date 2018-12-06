CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_analyse_income_member_new_old_daily;


CREATE TABLE IF NOT EXISTS ads_crm.member_analyse_income_member_new_old_daily (
    member_type             VARCHAR,
    order_channel           VARCHAR,
    sales_mode              VARCHAR,
    store_type              VARCHAR,
    store_level             VARCHAR,
    channel_type            VARCHAR,
    sales_income            DECIMAL(18, 3),
    sales_income_proportion DECIMAL(18, 4),
    compared_with_lyst      DECIMAL(18, 4),
    compared_with_ss_lyst   DECIMAL(18, 4),
    date                    DATE,
    create_time             TIMESTAMP,
    brand                   VARCHAR,
    zone                    VARCHAR,
    vchr_date               VARCHAR
) WITH (partitioned_by = array['brand', 'zone', 'vchr_date']);
