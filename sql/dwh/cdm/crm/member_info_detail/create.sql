CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_info_detail;


CREATE TABLE IF NOT EXISTS cdm_crm.member_info_detail (
    country                     VARCHAR,
    sales_area                  VARCHAR,
    sales_district              VARCHAR,
    province                    VARCHAR,
    city                        VARCHAR,
    register_store_code         VARCHAR,
    store_code                  VARCHAR,
    brand_name                  VARCHAR,
    sales_mode                  VARCHAR,
    store_type                  VARCHAR,
    store_level                 VARCHAR,
    channel_type                VARCHAR,
    member_no                   VARCHAR,
    wechat_id                   VARCHAR,
    member_code                 VARCHAR,
    member_card                 VARCHAR,
    member_name                 VARCHAR,
    member_birthday             DATE,
    member_gender               VARCHAR,
    member_phone                VARCHAR,
    member_mobile               VARCHAR,
    member_email                VARCHAR,
    reg_source                  VARCHAR,
    member_grade_id             INTEGER,
    member_score                DECIMAL(11,2),
    member_coupon_denomination  INTEGER,
    modify_time                 TIMESTAMP,
    member_will_score           DECIMAL(11,2),
    grade_expiration            TIMESTAMP,
    grade_begin                 TIMESTAMP,
    member_register_time        TIMESTAMP,
    member_first_order_time     TIMESTAMP,
    member_last_order_time      TIMESTAMP
);
