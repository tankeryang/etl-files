CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.order_grade_log_detail;


CREATE TABLE cdm_crm.order_grade_log_detail (
    member_no           VARCHAR,
    brand_code          VARCHAR,
    outer_order_no      VARCHAR,
    order_deal_time     TIMESTAMP,
    before_grade_id     INTEGER,
    before_grade_name   VARCHAR,
    after_grade_id      INTEGER,
    after_grade_name    VARCHAR,
    grade_change_time   TIMESTAMP,
    normal_upgrade_type VARCHAR    COMMENT '普通升级到更高等级',
    upgrade_type        VARCHAR    COMMENT '纯升级'
);
