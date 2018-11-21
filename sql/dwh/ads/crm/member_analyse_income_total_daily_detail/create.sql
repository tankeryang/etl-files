CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_analyse_income_total_daily_detail;


CREATE TABLE IF NOT EXISTS ads_crm.member_analyse_income_total_daily_detail (
    brand                   VARCHAR,
    order_channel           VARCHAR,
    zone                    VARCHAR,
    zone_type               VARCHAR,
    member_type             VARCHAR,
    sales_income            DECIMAL(18, 3),
    sales_income_proportion DECIMAL(18, 4),
    compared_with_lyst      DECIMAL(18, 4),
    compared_with_ss_lyst   DECIMAL(18, 4),
    date                    DATE,
    duration_type           VARCHAR,
    create_time             TIMESTAMP
);
