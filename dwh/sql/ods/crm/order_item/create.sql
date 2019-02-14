CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.order_item;


CREATE TABLE ods_crm.order_item (
    brand_code         VARCHAR,
    member_no          VARCHAR,
    order_item_no      VARCHAR,
    order_from         INTEGER        COMMENT '订单来源(1=线上/2=线下)',
    order_id           INTEGER        COMMENT '订单id',
    outer_order_no     VARCHAR        COMMENT '外部订单号',
    clerk_no           VARCHAR        COMMENT '导购员编号',
    item_type          VARCHAR        COMMENT '商品明细类型',
    original_order_id  INTEGER        COMMENT '原订单id',
    product_item_code  VARCHAR        COMMENT '产品编号(sku)',
    product_code       VARCHAR        COMMENT '商品编号(spu)',
    product_color_code VARCHAR        COMMENT '商品色号',
    product_size_code  VARCHAR        COMMENT '商品码数',
    quantity           INTEGER        COMMENT '商品数量',
    total_amount       DECIMAL(38, 2) COMMENT '吊牌金额',
    fact_amount        DECIMAL(38, 2) COMMENT '实际金额',
    discount_rate      DECIMAL(38, 2) COMMENT '折扣',
    currency           VARCHAR        COMMENT '币种',
    discount_type      VARCHAR        COMMENT '优惠方式',
    item_status        VARCHAR        COMMENT '商品状态',
    return_quantity    INTEGER        COMMENT '退货数',
    return_amount      DECIMAL(38, 2) COMMENT '退货金额',
    sub_coupon_amount  DECIMAL(38, 2) COMMENT '扣券后金额',
    order_deal_time    TIMESTAMP      COMMENT '关联订单表-pay_time',
    create_time        TIMESTAMP
) WITH (format = 'ORC');
