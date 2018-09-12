CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.member_analyse_base;


CREATE TABLE cdm_crm.member_analyse_base (
    country                 VARCHAR,
    sales_area              VARCHAR  COMMENT '大区',
    sales_district          VARCHAR  COMMENT '片区 - management_district_code',
    order_channel           VARCHAR  COMMENT '线上, 线下',
    province                VARCHAR,
    city                    VARCHAR,
    brand_code              VARCHAR,
    store_code              VARCHAR,
    sales_mode              VARCHAR  COMMENT '门店类别 - 短特, 长特, 正价',
    store_type              VARCHAR  COMMENT '门店类型 - MALL, 百货, 专卖店',
    store_level             VARCHAR  COMMENT '门店等级 - I, A, B, C, D',
    channel_type            VARCHAR  COMMENT '经营方式 - 自营, 联营, 特许',
    outer_order_no          VARCHAR,
    member_no               VARCHAR,
    member_grade_id         INTEGER,
    all                     VARCHAR  COMMENT '整体',
    member_type             VARCHAR  COMMENT '是否会员 - 会员, 非会员',
    member_newold_type      VARCHAR  COMMENT '新老会员分析 - 新会员, 老会员',
    member_level_type       VARCHAR  COMMENT '会员等级分析 - 普通会员, VIP会员',
    order_item_quantity     INTEGER,
    order_amount            DECIMAL(38, 2),
    order_fact_amount       DECIMAL(38, 2),
    member_register_time    TIMESTAMP,
    last_grade_change_time  TIMESTAMP,
    order_deal_time         TIMESTAMP,
    create_time             TIMESTAMP
);
