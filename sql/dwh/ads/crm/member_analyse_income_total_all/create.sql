CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_analyse_income_total_all;


CREATE TABLE IF NOT EXISTS ads_crm.member_analyse_income_total_all (
    brand                   VARCHAR,
    zone                    VARCHAR,
    zone_type               VARCHAR,
    member_type             VARCHAR,
    order_channel           VARCHAR,
    sales_mode              VARCHAR,
    store_type              VARCHAR,
    store_level             VARCHAR,
    channel_type            VARCHAR,
    sales_income            DECIMAL(18, 3),
    sales_income_proportion DECIMAL(18, 4),
    customer_amount         INTEGER,
    order_amount            INTEGER,
    consumption_frequency   INTEGER,
    sales_income_per_order  DECIMAL(18, 2),
    sales_income_per_item   DECIMAL(18, 2),
    sales_item_per_order    DECIMAL(18, 2),
    compared_with_lyst      DECIMAL(18, 4),
    compared_with_ss_lyst   DECIMAL(18, 4),
    duration_type           VARCHAR,
    create_time             TIMESTAMP
);
