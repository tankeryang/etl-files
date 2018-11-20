CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.member_info;


CREATE TABLE ods_crm.member_info (
    member_id                   INTEGER,
    member_no                   VARCHAR,
    brand_code                  VARCHAR,
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
    country                     VARCHAR,
    province                    VARCHAR,
    city                        VARCHAR,
    region                      VARCHAR,
    address                     VARCHAR,
    zip_code                    VARCHAR,
    identity_type               INTEGER,
    identity_number             VARCHAR,
    member_nick_name            VARCHAR,
    member_will_score           DECIMAL(11,2),
    grade_expiration            TIMESTAMP,
    grade_begin                 TIMESTAMP,
    last_update_time            TIMESTAMP,
    member_register_time        TIMESTAMP,
    member_register_store       VARCHAR,
    member_manage_store         VARCHAR,
    create_time                 TIMESTAMP
);
