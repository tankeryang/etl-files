CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_cumulative_consumption;


CREATE TABLE cdm_crm.member_cumulative_consumption (
    member_no                         VARCHAR,
    brand_code                        VARCHAR,
    store_code                        VARCHAR,
    consumption_order_no              VARCHAR        COMMENT '消费单号',
    retail_amount                     DECIMAL(18, 2) COMMENT '吊牌金额',
    consumption_amount                DECIMAL(18, 2) COMMENT '消费金额',
    consumption_amount_include_coupon DECIMAL(18, 2) COMMENT '消费金额(含券)',
    return_order_no                   VARCHAR        COMMENT '退款单号',
    return_amount                     DECIMAL(18, 2) COMMENT '退款金额',
    consumption_item_quantity         INTEGER        COMMENT '消费件数',
    consumption_date                  DATE           COMMENT '消费日期',
    consumption_time                  TIMESTAMP      COMMENT '消费时间',
    create_time                       TIMESTAMP
) WITH (format = 'ORC');
