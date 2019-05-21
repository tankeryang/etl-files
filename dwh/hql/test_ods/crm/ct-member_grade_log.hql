CREATE SCHEMA IF NOT EXISTS test_ods_crm;


DROP TABLE IF EXISTS test_ods_crm.member_grade_info;


CREATE TABLE IF NOT EXISTS test_ods_crm.member_grade_log (
    log_id                INTEGER,
    member_no             STRING,
    member_grade_order_no STRING,
    before_grade_id       INTEGER,
    after_grade_id        INTEGER,
    event_code            STRING,
    change_reason         SMALLINT,
    change_reason_desc    STRING,
    store_no              STRING,
    clerk_no              STRING,
    grade_change_time     TIMESTAMP,
    trigger_order_id      INTEGER,
    grade_expiration      TIMESTAMP,
    grade_begin           TIMESTAMP,
    outer_order_no        STRING,
    create_user           STRING,
    create_time           TIMESTAMP,
    status                INTEGER,
    brand_code            STRING
)
PARTITIONED BY (brand_code STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION 'hdfs://emr-cluster/user/hive/warehouse/test_ods_crm.db/';
