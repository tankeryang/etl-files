CREATE SCHEMA IF NOT EXISTS test_ods_crm;


DROP TABLE IF EXISTS test_ods_crm.member_info;


CREATE TABLE IF NOT EXISTS test_ods_crm.member_info (
    member_id                  INTEGER,
    member_no                  STRING,
    wechat_id                  STRING,
    member_code                STRING,
    member_card                STRING,
    member_name                STRING,
    member_birthday            DATE,
    member_gender              STRING,
    member_phone               STRING,
    member_mobile              STRING,
    member_email               STRING,
    reg_source                 STRING,
    member_from                SMALLINT,
    member_grade_id            INTEGER,
    member_score               DECIMAL(18, 2),
    member_coupon_denomination INTEGER,
    modify_time                TIMESTAMP,
    country                    STRING,
    province                   STRING,
    city                       STRING,
    region                     STRING,
    address                    STRING,
    zip_code                   STRING,
    identity_type              INTEGER,
    identity_number            STRING,
    member_nick_name           STRING,
    member_will_score          DECIMAL(18, 2),
    grade_expiration           TIMESTAMP,
    grade_begin                TIMESTAMP,
    create_time                TIMESTAMP,
    create_user                STRING,
    last_update_time           TIMESTAMP,
    update_user                STRING,
    member_register_time       TIMESTAMP,
    member_register_store      STRING,
    member_register_clerk      STRING,
    member_manage_clerk        STRING,
    member_manage_store        STRING,
    member_hobby               STRING,
    member_profession          STRING,
    status                     INTEGER,
    version                    INTEGER,
    brand_code                 STRING,
    recommend_member_no        STRING,
    trigger_type               STRING,
    taobao_nick                STRING,
    union_id                   STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION 'hdfs://emr-cluster/user/hive/warehouse/test_ods_crm.db/';
