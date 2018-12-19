CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_last_consumption;


CREATE TABLE cdm_crm.member_last_consumption (
    member_no                         VARCHAR,
    brand_code                        VARCHAR,
    store_code                        VARCHAR,
    consumption_amount                DECIMAL(18, 2) COMMENT '最近消费金额',
    consumption_amount_include_coupon DECIMAL(18, 2) COMMENT '最近消费金额(含券)',
    consumption_item_quantity         INTEGER        COMMENT '最近消费件数',
    consumption_date                  DATE           COMMENT '最近消费日期',
    consumption_gap                   INTEGER        COMMENT '最近消费间隙(最近一次消费时间距离今天的间隔天数)',
    create_time                       TIMESTAMP
);
