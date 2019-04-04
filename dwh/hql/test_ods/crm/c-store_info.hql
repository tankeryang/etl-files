CREATE SCHEMA IF NOT EXISTS test_ods_crm;


DROP TABLE IF EXISTS test_ods_crm.store_info;


CREATE TABLE IF NOT EXISTS test_ods_crm.store_info (
    store_id         INTEGER,
    store_code       STRING,
    store_name       STRING,
    channel_type     STRING,
    store_type       STRING,
    operation_state  STRING,
    brand_code       STRING,
    business_mode    STRING,
    country          STRING,
    sales_area       STRING,
    province         STRING,
    city             STRING,
    district         STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION 'hdfs://emr-cluster/user/hive/warehouse/test_ods_crm.db/';
