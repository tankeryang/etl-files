CREATE SCHEMA IF NOT EXISTS ods_mms;


DROP TABLE IF EXISTS ods_mms.commodity_info;


CREATE TABLE IF NOT EXISTS ods_mms.commodity_info (
    product_code VARCHAR,
    product_name VARCHAR,
    brand_code   VARCHAR,
    main_cate    VARCHAR,
    sub_cate     VARCHAR,
    leaf_cate    VARCHAR,
    series       VARCHAR,
    lining       VARCHAR,
    list_date    VARCHAR,
    retail_price DECIMAL(18, 2)
);
