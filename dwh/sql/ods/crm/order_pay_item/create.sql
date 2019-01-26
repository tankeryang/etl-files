CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.order_pay_item;


CREATE TABLE ods_crm.order_pay_item (
    pay_item_id     INTEGER        COMMENT '订单支付明细id',
    order_id        INTEGER        COMMENT '订单id',
    order_from      INTEGER        COMMENT '订单来源(1=线上/2-线下)',
    outer_order_no  VARCHAR        COMMENT '外部订单号',
    pay_type        VARCHAR        COMMENT '支付类型',
    currency        VARCHAR        COMMENT '币种',
    pay_amount      DECIMAL(38, 2) COMMENT '支付金额',
    coupon_no       VARCHAR        COMMENT '券号',
    order_deal_time TIMESTAMP      COMMENT '关联订单表-pay_time',
    create_time     TIMESTAMP
);
