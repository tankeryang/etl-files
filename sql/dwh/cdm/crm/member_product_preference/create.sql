CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_product_preference;


CREATE TABLE IF NOT EXISTS cdm_crm.member_product_preference (
    category_preference       AS VARCHAR,
    sub_cate_preference       AS VARCHAR,
    product_group_preference  AS VARCHAR,
    lining_preference         AS VARCHAR,
    price_baseline_preference AS VARCHAR,
    outline_preference        AS VARCHAR,
    color_preference          AS VARCHAR,
    size_preference           AS VARCHAR
);
