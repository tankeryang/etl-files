CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_analyse_group_info_detail;


CREATE TABLE IF NOT EXISTS ads_crm.member_analyse_group_info_detail (
    brand_code                             VARCHAR,
    brand_name                             VARCHAR,
    member_no                              VARCHAR,
    -- 客户基础信息
    member_birthday                        DATE,
    member_age                             INTEGER,
    member_register_time                   TIMESTAMP,
    reg_source                             VARCHAR,
    member_grade_id                        INTEGER,
    -- RFM模型(常用选项)
    last_order_deal_time                   TIMESTAMP,
    last_order_fact_amount                 DECIMAL(18, 2),
    last_order_deal_time_gap_with_today    INTEGER,
    first_order_deal_time                  TIMESTAMP,
    first_order_deal_amount                DECIMAL(18, 2),
    first_order_deal_time_gap_with_today   INTEGER,
    -- 产品属性偏好
    main_cate_preference                   VARCHAR,
    sub_cate_preference                    VARCHAR,
    leaf_cate_preference                   VARCHAR,
    product_group_preference               VARCHAR,
    lining_preference                      VARCHAR,
    price_baseline_preference              VARCHAR,
    outline_preference                     VARCHAR,
    color_preference                       VARCHAR,
    size_preference                        VARCHAR,
    -- 购物偏好
    store_preference                       VARCHAR,
    pay_type_preference                    VARCHAR,
    related_rate                           VARCHAR,
    discount_rate                          DECIMAL(18, 4),
    coupon_discount_rate                   DECIMAL(18, 4),
    uncoupon_discount_rate                 DECIMAL(18, 4),
    -- 会员相关
    member_score                           DECIMAL(18, 4),
    -- RFM模型(高级选项)
    average_order_fact_amount              DECIMAL(18, 4),
    average_order_deal_time_gap_with_today INTEGER,
    cumulated_consumed_amount              INTEGER,
    cumulated_order_fact_amount            DECIMAL(18, 4),
    cumulated_order_count                  INTEGER,
    cumulated_item_amount                  INTEGER,
    return_count                           INTEGER,
    return_amount                          DECIMAL(18, 4)
);
