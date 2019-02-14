CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_coupon_order_info_detail;


CREATE TABLE ads_crm.member_coupon_order_info_detail (
    brand_code                       VARCHAR,
    member_no                        VARCHAR,
    member_name                      VARCHAR,
    member_mobile                    VARCHAR,
    member_wechat_id                 VARCHAR,
    member_manage_store_code         VARCHAR,
    member_manage_store_name         VARCHAR,
    coupon_no                        VARCHAR,
    coupon_name                      VARCHAR,
    coupon_passcode                  VARCHAR,
    coupon_status                    VARCHAR,
    coupon_batch_time                TIMESTAMP,
    coupon_batch_date                VARCHAR,
    coupon_start_time                TIMESTAMP,
    coupon_start_date                VARCHAR,
    coupon_end_time                  TIMESTAMP,
    coupon_end_date                  VARCHAR,
    coupon_template_no               VARCHAR,
    coupon_template_name             VARCHAR,
    coupon_category                  VARCHAR,
    coupon_type                      VARCHAR,
    coupon_type_detail               VARCHAR,
    coupon_denomination              DECIMAL(18, 2),
    coupon_used_time                 TIMESTAMP,
    coupon_used_date                 VARCHAR,
    coupon_used_order_no             VARCHAR,
    order_store_code                 VARCHAR,
    order_store_name                 VARCHAR,
    order_trade_source               VARCHAR,
    order_grade_id                   INTEGER,
    order_retail_amount              DECIMAL(18, 2),
    order_fact_amount                DECIMAL(18, 2),
    order_fact_amount_include_coupon DECIMAL(18, 2),
    order_discount                   DECIMAL(18, 2),
    order_item_quantity              INTEGER
) WITH (format = 'ORC');
