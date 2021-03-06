CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.order_info;


CREATE TABLE ods_crm.order_info (
    order_id              INTEGER        COMMENT '订单id',
    outer_order_no        VARCHAR        COMMENT '外部订单号',
    order_from            VARCHAR        COMMENT '订单来源(1=线上/2=线下)',
    trade_source          VARCHAR        COMMENT '系统来源(fpos/ipos...)',
    brand_code            VARCHAR        COMMENT '品牌编号',
    store_code            VARCHAR        COMMENT '门店编号',
    order_deal_time       TIMESTAMP      COMMENT '订单支付时间',
    member_no             VARCHAR        COMMENT '会员编号',
    order_grade           INTEGER        COMMENT '当前订单会员等级',
    order_item_quantity   INTEGER        COMMENT '当前订单商品数量',
    order_amount          DECIMAL(38, 2) COMMENT '吊牌金额',
    order_fact_amount     DECIMAL(38, 2) COMMENT '实际交易额',
    order_status          VARCHAR        COMMENT '订单状态',
    outer_return_order_no VARCHAR        COMMENT '外部退货订单号',
    create_time           TIMESTAMP
) WITH (format = 'ORC');
