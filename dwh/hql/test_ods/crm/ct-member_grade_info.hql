CREATE SCHEMA IF NOT EXISTS test_ods_crm;


DROP TABLE IF EXISTS test_ods_crm.member_grade_info;


CREATE TABLE IF NOT EXISTS test_ods_crm.member_grade_info (
    id                    INTEGER,
    grade_id              INTEGER,
    grade_code            STRING,
    grade_name            STRING,
    grade_desc            STRING,
    parent_grade_id       INTEGER,
    priority              SMALLINT,
    store_id              SMALLINT,
    grade_discount        DECIMAL(18, 2),
    status                TINYINT,
    create_time           TIMESTAMP,
    create_user           STRING,
    update_time           TIMESTAMP,
    update_user           STRING,
    grade_validity_months INTEGER,
    next_grade_id         INTEGER,
    brand_code            STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION 'hdfs://emr-cluster/user/hive/warehouse/test_ods_crm.db/';
