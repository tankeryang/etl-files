CREATE SCHEMA IF NOT EXISTS dwd_crm;


DROP TABLE IF EXISTS dwd_crm.order_grade_log;


CREATE TABLE dwd_crm.order_grade_log (
    member_no             VARCHAR,
    brand_code            VARCHAR,
    outer_order_no        VARCHAR,
    is_normal_upgrade     TINYINT    COMMENT '是否普通升级到更高等级(1:是/0:否)',
    is_upgrade            TINYINT    COMMENT '是否纯升级(1:是/0:否)',
    before_grade_id       INTEGER,
    before_grade_name     VARCHAR,
    after_grade_id        INTEGER,
    after_grade_name      VARCHAR,
    grade_change_time     TIMESTAMP,
    order_deal_time       TIMESTAMP,
    order_deal_date       DATE,
    order_deal_year_month VARCHAR,
    order_deal_year       INTEGER,
    order_deal_month      INTEGER,
    create_time           TIMESTAMP
);
