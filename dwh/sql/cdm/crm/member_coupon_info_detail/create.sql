CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_coupon_info_detail;


CREATE TABLE IF NOT EXISTS cdm_crm.member_coupon_info_detail (
    member_no            VARCHAR,
    brand_code           VARCHAR,
    coupon_no            VARCHAR        COMMENT '券号',
    coupon_template_no   VARCHAR        COMMENT '券批次号',
    coupon_template_name VARCHAR        COMMENT '券头',
    coupon_status        VARCHAR        COMMENT '券状态',
    coupon_category      VARCHAR        COMMENT '券类别/券批次类型(现金券/折扣券)',
    coupon_discount      DECIMAL(18, 2) COMMENT '券折扣',
    coupon_denomination  DECIMAL(18, 2) COMMENT '券面额',
    coupon_type          VARCHAR        COMMENT '券类型(品牌/集团)',
    coupon_type_detail   VARCHAR        COMMENT '券/券批次类型描述(活动/生日/入会/粉丝...)',
    coupon_batch_time    TIMESTAMP      COMMENT '券绑定时间',
    coupon_batch_date    VARCHAR        COMMENT '券绑定日期',
    coupon_batch_status  VARCHAR        COMMENT '券绑定状态',
    coupon_start_time    TIMESTAMP      COMMENT '券开始时间',
    coupon_start_date    VARCHAR        COMMENT '券开始日期',
    coupon_end_time      TIMESTAMP      COMMENT '券截止时间',
    coupon_end_date      VARCHAR        COMMENT '券截止日期',
    coupon_used_order_no VARCHAR        COMMENT '券使用订单号',
    coupon_used_time     TIMESTAMP      COMMENT '券使用时间',
    coupon_used_date     VARCHAR        COMMENT '券使用日期',
    create_time          TIMESTAMP
);
