CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_analyse_index_label;


CREATE TABLE IF NOT EXISTS cdm_crm.member_analyse_index_label (
    country                VARCHAR,
    sales_area             VARCHAR,
    sales_district         VARCHAR,
    order_channel          VARCHAR,
    province               VARCHAR,
    city                   VARCHAR,
    store_code             VARCHAR,
    brand_code             VARCHAR,
    brand_name             VARCHAR,
    sales_mode             VARCHAR,
    store_type             VARCHAR,
    store_level            VARCHAR,
    channel_type           VARCHAR,
    member_type            VARCHAR,
    member_nowbefore_type  VARCHAR,
    member_newold_type     VARCHAR,
    member_level_type      VARCHAR,
    dr_member_type         VARCHAR
);
