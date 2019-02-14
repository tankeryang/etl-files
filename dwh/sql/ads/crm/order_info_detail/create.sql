CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.order_info_detail;


CREATE TABLE ads_crm.order_info_detail (
    country                          VARCHAR,
    sales_area                       VARCHAR  COMMENT '大区',
    sales_district                   VARCHAR  COMMENT '片区 - management_district_code',
    order_channel                    VARCHAR  COMMENT '线上, 线下',
    trade_sourde                     VARCHAR  COMMENT '订单渠道',
    province                         VARCHAR,
    city                             VARCHAR,
    brand_code                       VARCHAR,
    brand_name                       VARCHAR,
    store_code                       VARCHAR,
    store_name                       VARCHAR,
    sales_mode                       VARCHAR  COMMENT '门店类别 - 短特, 长特, 正价',
    store_type                       VARCHAR  COMMENT '门店类型 - MALL, 百货, 专卖店',
    store_level                      VARCHAR  COMMENT '门店等级 - I, A, B, C, D',
    channel_type                     VARCHAR  COMMENT '经营方式 - 自营, 联营, 特许',
    outer_order_no                   VARCHAR,
    member_no                        VARCHAR,
    member_grade_id                  INTEGER,
    member_type                      VARCHAR  COMMENT '是否会员 - 会员, 非会员',
    member_newold_type               VARCHAR  COMMENT '新老会员分析 - 新会员, 老会员',
    member_level_type                VARCHAR  COMMENT '会员等级分析 - 普通会员, VIP会员',
    member_upgrade_type              VARCHAR  COMMENT '会员升级类型 - 升级, 未升级',
    member_register_type             VARCHAR  COMMENT '会员注册类型 - 门店, 官网',
    member_recruit_type              VARCHAR  COMMENT '招募会员-有消费会员类型 - 普通会员, VIP会员, 升级会员',
    dr_member_type                   VARCHAR  COMMENT '日报会员类型 - 新会员, 普通会员, VIP会员',
    order_item_quantity              INTEGER,
    order_amount                     DECIMAL(38, 2),
    order_fact_amount                DECIMAL(38, 2),
    order_fact_amount_include_coupon DECIMAL(38, 2),
    order_type_num                   INTEGER,
    order_coupon_no                  ARRAY<VARCHAR>,
    order_coupon_category            VARCHAR,
    order_coupon_denomination        DECIMAL(18, 2),
    member_register_time             TIMESTAMP,
    last_grade_change_time           TIMESTAMP,
    order_deal_time                  TIMESTAMP,
    order_deal_date                  DATE,
    create_time                      TIMESTAMP,
    year_month                       VARCHAR,
    vchr_date                        VARCHAR
) WITH (partitioned_by = array['year_month', 'vchr_date'], format = 'ORC');
