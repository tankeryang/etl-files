CREATE SCHEMA IF NOT EXISTS test_ods_crm;


DROP TABLE IF EXISTS test_ods_crm.order_info;


CREATE TABLE IF NOT EXISTS test_ods_crm.order_info (
    order_id                  INTEGER,
    outer_order_no            STRING,
    store_code                STRING,
    clerk_no                  STRING,
    order_create_time         TIMESTAMP,
    member_no                 STRING,
    order_grade               INTEGER,
    order_item_quantity       INTEGER,
    order_amount              DECIMAL(18, 2),
    order_fact_amount         DECIMAL(18, 2),
    order_status              STRING,
    outer_return_order_no     STRING,
    order_from                SMALLINT,
    country                   STRING,
    province                  STRING,
    city                      STRING,
    region                    STRING,
    address                   STRING,
    pay_time                  TIMESTAMP,
    fact_freight              DECIMAL(18, 2),
    currency                  STRING,
    discount_type             STRING,
    trade_source              STRING,
    create_time               TIMESTAMP,
    last_update_time          TIMESTAMP,
    store_id                  SMALLINT,
    crm_org_id                BIGINT,
    mobile                    STRING,
    zip_code                  STRING,
    receiver_name             STRING,
    pos_input_flag            INTEGER,
    pos_order_fact_amount     DECIMAL(18, 2),
    pos_order_discount_amount DECIMAL(18, 2)
)
PARTITIONED BY (brand_code STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION 'hdfs://emr-cluster/user/hive/warehouse/test_ods_crm.db/';
