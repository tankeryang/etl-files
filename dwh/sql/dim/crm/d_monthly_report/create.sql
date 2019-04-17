CREATE SCHEMA IF NOT EXISTS dim_crm;


DROP TABLE IF EXISTS dim_crm.d_monthly_report;


CREATE TABLE IF NOT EXISTS dim_crm.d_monthly_report (
    brand_code             VARCHAR COMMENT '品牌编号',
    brand_name             VARCHAR COMMENT '品牌名称',
    channel_type           VARCHAR COMMENT '渠道',
    mr_member_grade_type   VARCHAR COMMENT '月报会员等级类型 - (普通会员/VIP)',
    mr_member_new_old_type VARCHAR COMMENT '月报会员新老类型 - (新会员/老会员)',
    mr_member_sales_type   VARCHAR COMMENT '月报会员销售类型 - (有消费/无消费)'
) WITH (format = 'ORC');
