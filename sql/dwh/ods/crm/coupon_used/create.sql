CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.coupon_used;


CREATE TABLE IF NOT EXISTS ods_crm.coupon_used (
    coupon_no      VARCHAR,
    coupon_status  INTEGER,
    outer_order_no VARCHAR,
    member_no      VARCHAR,
    brand_code     VARCHAR,
    order_time     TIMESTAMP,
    create_time    TIMESTAMP
);
