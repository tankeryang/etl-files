CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_first_order;


CREATE TABLE cdm_crm.member_first_order (
    member_no              VARCHAR,
    brand_code             VARCHAR,
    mr_member_new_old_type VARCHAR COMMENT '吊毛月报的新老会员类型, 在这里统一为 NEW, 方便后续用 order_info left join 它',
    order_deal_time        TIMESTAMP,
    order_deal_date        DATE,
    order_deal_year_month  VARCHAR     
) WITH (format = 'ORC');
