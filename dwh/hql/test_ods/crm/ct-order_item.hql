CREATE SCHEMA IF NOT EXISTS test_ods_crm;


DROP TABLE IF EXISTS test_ods_crm.order_info;


CREATE TABLE IF NOT EXISTS test_ods_crm.order_item (
    order_item_no       INTEGER,
    order_from          SMALLINT,
    order_id            INTEGER,
    outer_order_no      VARCHAR,
    outer_order_item_no VARCHAR,
    clerk_no            VARCHAR,
    item_type           VARCHAR,
    original_order_id   INTEGER,
    product_item_code   VARCHAR,
    product_code        VARCHAR,
    product_color_code  VARCHAR,
    product_size_code   VARCHAR,
    quantity            INTEGER,
    total_amount        DECIMAL,
    fact_amount         DECIMAL,
    discount_rate       DECIMAL,
    currency            VARCHAR,
    discount_type       VARCHAR,
    item_status         VARCHAR,
    return_quantity     INTEGER,
    return_amount       DECIMAL,
    sub_coupon_amount   DECIMAL,
    memo                VARCHAR,
    create_time         TIMESTAMP,
    pos_fact_amount     DECIMAL,
    pos_discount_amount DECIMAL,
    pos_input_type      VARCHAR
)
PARTITIONED BY (brand_code STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION 'hdfs://emr-cluster/user/hive/warehouse/test_ods_crm.db/';
