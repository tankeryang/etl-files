CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_consumption_preference;


CREATE TABLE IF NOT EXISTS cdm_crm.member_consumption_preference (
    brand_code                        VARCHAR,
    member_no                         VARCHAR,
    store_preference                  VARCHAR,
    pay_type_preference               VARCHAR,
    related_rate_preference           VARCHAR,
    discount_rate_preference          DECIMAL(18, 4),
    coupon_discount_rate_preference   DECIMAL(18, 4),
    uncoupon_discount_rate_preference DECIMAL(18, 4),
    computiong_duration               VARCHAR
);
