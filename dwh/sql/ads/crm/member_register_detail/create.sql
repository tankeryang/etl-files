CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_register_detail;


CREATE TABLE IF NOT EXISTS ads_crm.member_register_detail (
    country                  VARCHAR,
    sales_area               VARCHAR,
    sales_district           VARCHAR,
    province                 VARCHAR,
    city                     VARCHAR,
    register_store_code      VARCHAR,
    store_code               VARCHAR,
    brand_name               VARCHAR,
    sales_mode               VARCHAR,
    store_type               VARCHAR,
    store_level              VARCHAR,
    channel_type             VARCHAR,
    register_member_array    ARRAY<VARCHAR>,
    date                     DATE
) WITH (format = 'ORC');
