CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.order_coupon_info_detail;


CREATE TABLE cdm_crm.order_coupon_info_detail (
    outer_order_no          VARCHAR,
    coupon_no_array         ARRAY<VARCHAR>,
    coupon_category         VARCHAR,
    coupon_denomination_sum DECIMAL(18, 2),
    order_time              TIMESTAMP,
    create_time             TIMESTAMP
) WITH (format = 'ORC');
