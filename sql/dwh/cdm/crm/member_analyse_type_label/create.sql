CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_analyse_type_label;


CREATE TABLE IF NOT EXISTS cdm_crm.member_analyse_type_label (
    country                VARCHAR,
    sales_area             VARCHAR,
    sales_district         VARCHAR,
    order_channel          VARCHAR,
    province               VARCHAR,
    city                   VARCHAR,
    sales_mode             VARCHAR,
    store_type             VARCHAR,
    store_level            VARCHAR,
    channel_type           VARCHAR,
    all                    VARCHAR,
    member_type            VARCHAR,
    member_nowbefore_type  VARCHAR,
    member_newold_type     VARCHAR,
    member_level_type      VARCHAR
);
