CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_analyse_group_info_detail;


CREATE TABLE IF NOT EXISTS ads_crm.member_analyse_group_info_detail (
    member_no  AS VARCHAR,
    -- 客户基础信息
    member_birthday AS DATE,
    member_age      AS INTEGER,
    member_register_time AS TIMESTAMP,
    reg_source           AS VARCHAR,
    member_grade_id      AS INTEGER,
    -- RFM模型(常用选项)
    last_order_deal_time AS TIMESTAMP,
    last_order_fact_amount AS DECIMAL(38, 2),
    last_order_deal_time_gap_with_today AS INTEGER,
    first_order_deal_time               AS TIMESTAMP,
    first_order_deal_amount             AS DECIMAL(38, 2),
    first_order_deal_time_gap_with_today AS INTEGER,
    -- 产品属性偏好
    category_preference                  AS VARCHAR,
    sub_cate_preference                  AS VARCHAR,
    product_group_preference             AS VARCHAR,
    lining_preference                    AS VARCHAR,
    price_baseline_preference            AS VARCHAR,
    
)