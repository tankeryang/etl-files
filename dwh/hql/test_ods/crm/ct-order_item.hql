CREATE SCHEMA IF NOT EXISTS test_ods_crm;


DROP TABLE IF EXISTS test_ods_crm.order_info;


CREATE TABLE IF NOT EXISTS test_ods_crm.order_item (
    order_item_no       INTEGER,
    order_from          SMALLINT,
    order_id            INTEGER,
    outer_order_no      STRING,
    outer_order_item_no STRING,
    clerk_no            STRING,
    item_type           STRING,
    original_order_id   INTEGER,
    product_item_code   STRING,
    product_code        STRING,
    product_color_code  STRING,
    product_size_code   STRING,
    quantity            INTEGER,
    total_amount        DECIMAL(18, 2),
    fact_amount         DECIMAL(18, 2),
    discount_rate       DECIMAL(18, 2),
    currency            STRING,
    discount_type       STRING,
    item_status         STRING,
    return_quantity     INTEGER,
    return_amount       DECIMAL(18, 2),
    sub_coupon_amount   DECIMAL(18, 2),
    memo                STRING,
    create_time         TIMESTAMP,
    pos_fact_amount     DECIMAL(18, 2),
    pos_discount_amount DECIMAL(18, 2),
    pos_input_type      STRING
)
PARTITIONED BY (brand_code STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION 'hdfs://emr-cluster/user/hive/warehouse/test_ods_crm.db/';
