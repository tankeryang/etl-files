CREATE SCHEMA IF NOT EXISTS test_ods_crm;


DROP TABLE IF EXISTS test_ods_crm.order_info;


CREATE TABLE IF NOT EXISTS test_ods_crm.order_info (
    order_id              INTEGER        COMMENT '订单id',
    outer_order_no        STRING         COMMENT '外部订单号',
    order_from            STRING         COMMENT '订单来源(1=线上/2=线下)',
    trade_source          STRING         COMMENT '系统来源(fpos/ipos...)',
    store_code            STRING,
    order_deal_time       TIMESTAMP,
    member_no             STRING,
    order_grade           INTEGER        COMMENT '当前订单会员等级',
    order_item_quantity   INTEGER        COMMENT '当前订单商品数量',
    order_amount          DECIMAL(18, 2) COMMENT '吊牌金额',
    order_fact_amount     DECIMAL(18, 2) COMMENT '实际交易额',
    order_status          STRING         COMMENT '订单状态',
    outer_return_order_no STRING         COMMENT '外部退货订单号',
    create_time           TIMESTAMP
)
PARTITIONED BY (brand_code STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION 'hdfs://emr-cluster/user/hive/warehouse/test_ods_crm.db/';
