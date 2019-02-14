CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.store_info_detail;


CREATE TABLE IF NOT EXISTS cdm_crm.store_info_detail (
    store_code       VARCHAR,
    store_name       VARCHAR,
    channel_type     VARCHAR,
    store_type       VARCHAR,
    store_level      VARCHAR,
    sales_mode       VARCHAR,
    operation_state  VARCHAR,
    brand_code       VARCHAR,
    business_mode    VARCHAR,
    country          VARCHAR,
    cms_country      VARCHAR,
    province         VARCHAR,
    sales_area       VARCHAR,
    sales_district   VARCHAR,
    city             VARCHAR,
    district         VARCHAR,
    company_name     VARCHAR,
    create_time      TIMESTAMP
) WITH (format = 'ORC');