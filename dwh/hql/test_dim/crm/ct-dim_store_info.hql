CREATE SCHEMA IF NOT EXISTS test_dim_crm;


DROP TABLE IF EXISTS test_dim_crm.dim_store_info;


CREATE TABLE IF NOT EXISTS test_dim_crm.dim_store_info (
    id                 INTEGER,
    store_id           INTEGER,
    store_no           STRING,
    store_name         STRING,
    channel_type       STRING,
    cms_no             STRING,
    business_mode_code STRING,
    business_mode      STRING,
    country            STRING,
    region             STRING,
    province           STRING,
    city               STRING,
    district           STRING,
    store_type         STRING,
    operation_state    STRING,
    create_time        TIMESTAMP,
    last_update_time   TIMESTAMP,
    create_user        STRING,
    update_user        STRING,
    brand_code         STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION 'hdfs://emr-cluster/user/hive/warehouse/test_dim_crm.db/';
