CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_cumulative_consumption_daily_detail;


CREATE TABLE IF NOT EXISTS ads_crm.member_cumulative_consumption_daily_detail (
    member_no                             VARCHAR,
    brand_code                            VARCHAR,
    cml_consumption_store                 ARRAY<VARCHAR>,
    cml_consumption_times                 INTEGER,
    cml_consumption_item_quantity         INTEGER,
    cml_consumption_retail_amount         DECIMAL(18, 2),
    cml_consumption_amount                DECIMAL(18, 2),
    cml_consumption_amount_include_coupon DECIMAL(18, 2),
    cml_return_times                      INTEGER,
    cml_return_amount                     DECIMAL(18, 2),
    cml_order_deal_date                   DATE,
    vchr_cml_order_deal_year_month        VARCHAR,
    vchr_cml_order_deal_date              VARCHAR
) WITH (partitioned_by = ARRAY['vchr_cml_order_deal_year_month', 'vchr_cml_order_deal_date']);
