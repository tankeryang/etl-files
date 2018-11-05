CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.coupon_info;


CREATE TABLE IF NOT EXISTS ods_crm.coupon_info (
    coupon_no           VARCHAR,
    coupon_start_time   TIMESTAMP,
    coupon_end_time     TIMESTAMP,
    coupon_status       VARCHAR,
    coupon_batch_status VARCHAR,
    member_no           VARCHAR,
    brand_code          VARCHAR,
    coupon_type         VARCHAR,
    coupon_type_detail  VARCHAR,
    coupon_category     VARCHAR,
    coupon_denomination DECIMAL(18, 2),
    coupon_discount     DECIMAL(18, 2),
    create_time         TIMESTAMP 
);
