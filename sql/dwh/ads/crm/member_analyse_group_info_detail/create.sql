CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_analyse_group_info_detail;


CREATE TABLE IF NOT EXISTS ads_crm.member_analyse_group_info_detail (
    brand_code                             AS VARCHAR,
    brand_name                             AS VARCHAR,
    member_no                              AS VARCHAR,
    -- 客户基础信息
    member_birthday                        AS DATE,
    member_age                             AS INTEGER,
    member_register_time                   AS TIMESTAMP,
    reg_source                             AS VARCHAR,
    member_grade_id                        AS INTEGER,
    -- RFM模型(常用选项)
    last_order_deal_time                   AS TIMESTAMP,
    last_order_fact_amount                 AS DECIMAL(18, 2),
    last_order_deal_time_gap_with_today    AS INTEGER,
    first_order_deal_time                  AS TIMESTAMP,
    first_order_deal_amount                AS DECIMAL(18, 2),
    first_order_deal_time_gap_with_today   AS INTEGER,
    -- 产品属性偏好
    main_cate_preference                   AS VARCHAR,
    sub_cate_preference                    AS VARCHAR,
    leaf_cate_preference                   AS VARCHAR,
    product_group_preference               AS VARCHAR,
    lining_preference                      AS VARCHAR,
    price_baseline_preference              AS VARCHAR,
    outline_preference                     AS VARCHAR,
    color_preference                       AS VARCHAR,
    size_preference                        AS VARCHAR,
    -- 购物偏好
    store_preference                       AS VARCHAR,
    pay_type_preference                    AS VARCHAR,
    related_rate                           AS VARCHAR,
    discount_rate                          AS DECIMAL(18, 4),
    coupon_discount_rate                   AS DECIMAL(18, 4),
    uncoupon_discount_rate                 AS DECIMAL(18, 4),
    -- 会员相关
    member_score                           AS DECIMAL(18, 4),
    -- RFM模型(高级选项)
    average_order_fact_amount              AS DECIMAL(18, 4),
    average_order_deal_time_gap_with_today AS INTEGER,
    cumulated_consumed_amount              AS INTEGER,
    cumulated_order_fact_amount            AS DECIMAL(18, 4),
    cumulated_order_count                  AS INTEGER,
    cumulated_item_amount                  AS INTEGER,
    return_count                           AS INTEGER,
    return_amount                          AS DECIMAL(18, 4)
);
