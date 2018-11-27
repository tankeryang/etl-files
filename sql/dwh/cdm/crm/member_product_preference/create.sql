CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_product_preference;


CREATE TABLE IF NOT EXISTS cdm_crm.member_product_preference (
    brand_code                VARCHAR,
    member_no                 VARCHAR,
    main_cate_preference      VARCHAR,
    sub_cate_preference       VARCHAR,
    leaf_cate_preference      VARCHAR,
    product_group_preference  VARCHAR,
    lining_preference         VARCHAR,
    price_baseline_preference VARCHAR,
    outline_preference        VARCHAR,
    color_preference          VARCHAR,
    size_preference           VARCHAR,
    computing_duration        VARCHAR
);
