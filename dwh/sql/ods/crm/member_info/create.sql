CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.member_info;


CREATE TABLE ods_crm.member_info (
    member_id                   INTEGER,
    member_no                   VARCHAR,
    brand_code                  VARCHAR,
    country                     VARCHAR,
    province                    VARCHAR,
    city                        VARCHAR,
    region                      VARCHAR,
    address                     VARCHAR,
    zip_code                    VARCHAR,
    member_identity_type        INTEGER       COMMENT '证件类型',
    member_identity_number      VARCHAR       COMMENT '证件编号',
    member_wechat_id            VARCHAR       COMMENT '微信号',
    member_taobao_nick          VARCHAR       COMMENT '淘宝昵称',
    member_code                 VARCHAR       COMMENT '会员顾客代码',
    member_card                 VARCHAR       COMMENT '会员卡号',
    member_name                 VARCHAR       COMMENT '会员姓名',
    member_nick_name            VARCHAR       COMMENT '会员昵称',
    member_birthday             DATE          COMMENT '会员生日',
    member_gender               VARCHAR       COMMENT '会员性别',
    member_phone                VARCHAR       COMMENT '会员电话',
    member_mobile               VARCHAR       COMMENT '会员手机',
    member_email                VARCHAR       COMMENT '会员邮箱',
    member_reg_source           VARCHAR       COMMENT '会员注册渠道',
    member_register_time        TIMESTAMP     COMMENT '会员注册时间',
    member_register_store       VARCHAR       COMMENT '会员注册门店',
    member_manage_store         VARCHAR       COMMENT '会员管理门店',
    member_grade_id             INTEGER       COMMENT '会员等级id',
    member_grade_begin          TIMESTAMP     COMMENT '会员等级开始日期',
    member_grade_expiration     TIMESTAMP     COMMENT '会员等级到期日期',
    member_score                DECIMAL(11,2) COMMENT '会员当前积分',
    member_will_score           DECIMAL(11,2) COMMENT '会员未到账积分',
    member_coupon_denomination  INTEGER       COMMENT '会员优惠券面额',
    member_status               INTEGER       COMMENT '会员状态(正常/异常卡)',
    member_ec_status            INTEGER       COMMENT '会员ec状态(正常/异常卡)',
    modify_time                 TIMESTAMP,
    last_update_time            TIMESTAMP,
    create_time                 TIMESTAMP
);
