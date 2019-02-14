CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.order_item_detail;


CREATE TABLE IF NOT EXISTS cdm_crm.order_item_detail (
    brand_code         VARCHAR,
    member_no          VARCHAR,
    outer_order_no     VARCHAR,
    item_type          VARCHAR,
    product_item_code  VARCHAR,
    product_code       VARCHAR,
    product_color_code VARCHAR,
    product_size_code  VARCHAR,
    -- main_cate          VARCHAR,
    -- sub_cate           VARCHAR,
    -- leaf_cate          VARCHAR,
    -- lining             VARCHAR,
    quantity           INTEGER,
    total_amount       DECIMAL(18, 2),
    fact_amount        DECIMAL(18, 2),
    discount_rate      DECIMAL(18, 2),
    order_deal_time    TIMESTAMP,
    create_time        TIMESTAMP
) WITH (format = 'ORC');
