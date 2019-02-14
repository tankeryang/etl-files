CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_analyse_daily_income_detail;


CREATE TABLE IF NOT EXISTS ads_crm.member_analyse_daily_income_detail(
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
    trade_source            VARCHAR,
    -- 需求字段
    member_type             VARCHAR,
    member_newold_type      VARCHAR,
    member_level_type       VARCHAR,
    member_upgrade_type     VARCHAR,
    member_register_type    VARCHAR,
    sales_income            DECIMAL(18, 3),
    sales_item_quantity     INTEGER,
    lyst_sales_income       DECIMAL(18, 3),
    customer_array          ARRAY<VARCHAR>,
    order_amount            INTEGER,
    date                    DATE,
    year                    VARCHAR,
    month                   VARCHAR
) WITH (format = 'ORC');
