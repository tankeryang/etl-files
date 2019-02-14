CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_rfm;


--user_rfmc基础表  每月第一天凌晨定时统计昨天往前1年、2年的数据
CREATE TABLE cdm_crm.member_rfm (
    member_no                 VARCHAR,
    computing_duration        INTEGER,
    grade_code                VARCHAR,
    recency                   BIGINT,
    frequency                 BIGINT,
    monetary_total            DECIMAL(38, 2),
    order_count               BIGINT,
    monetary_per_order        DECIMAL(38, 2),
    circle_first_repurchase   BIGINT,
    circle_average_repurchase BIGINT,
    computing_until_month     VARCHAR,
    create_time               TIMESTAMP
) WITH (format = 'ORC');



