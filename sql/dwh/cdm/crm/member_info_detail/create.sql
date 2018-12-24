CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_info_detail;


CREATE TABLE IF NOT EXISTS cdm_crm.member_info_detail (
    member_no                   VARCHAR,
    brand_code                  VARCHAR,
    brand_name                  VARCHAR,
    country                     VARCHAR,
    sales_area                  VARCHAR,
    sales_district              VARCHAR,
    province                    VARCHAR,
    city                        VARCHAR,
    store_code                  VARCHAR,
    store_name                  VARCHAR,
    sales_mode                  VARCHAR,
    store_type                  VARCHAR,
    store_level                 VARCHAR,
    channel_type                VARCHAR,
    member_wechat_id            VARCHAR,
    member_taobao_nick          VARCHAR,
    member_code                 VARCHAR,
    member_card                 VARCHAR,
    member_name                 VARCHAR,
    member_nick_name            VARCHAR,
    member_birthday             DATE,
    member_gender               VARCHAR,
    member_phone                VARCHAR,
    member_mobile               VARCHAR,
    member_email                VARCHAR,
    member_reg_source           VARCHAR,
    member_register_store       VARCHAR,
    member_register_time        TIMESTAMP,
    member_grade_id             INTEGER,
    member_grade_begin          TIMESTAMP,
    member_grade_expiration     TIMESTAMP,
    member_score                DECIMAL(11, 2),
    member_will_score           DECIMAL(11, 2),
    member_coupon_denomination  INTEGER,
    member_first_order_time     TIMESTAMP,
    member_last_order_time      TIMESTAMP,
    member_status               INTEGER,
    member_ec_status            INTEGER,
    modify_time                 TIMESTAMP,
    create_time                 TIMESTAMP
);
