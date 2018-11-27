CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_recruit_analyse_fold_daily_income_detail;


CREATE TABLE IF NOT EXISTS ads_crm.member_recruit_analyse_fold_daily_income_detail(
    -- 筛选条件(where and group by)
    country                 VARCHAR,
    sales_area              VARCHAR,
    sales_district          VARCHAR,
    province                VARCHAR,
    city                    VARCHAR,
    brand_code              VARCHAR,
    brand_name              VARCHAR,
    store_code              VARCHAR,
    sales_mode              VARCHAR,
    store_type              VARCHAR,
    store_level             VARCHAR,
    channel_type            VARCHAR,
    order_channel           VARCHAR,
    -- 需求字段
    member_recruit_type     VARCHAR,
    member_register_type    VARCHAR,
    customer_array          ARRAY<VARCHAR>,
    date                    DATE
);
