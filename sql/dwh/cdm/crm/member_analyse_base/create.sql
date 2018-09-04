DROP TABLE IF EXISTS cdm_crm.member_analyse_base;


CREATE TABLE cdm_crm.member_analyse_base (
    country                 VARCHAR,
    sales_area              VARCHAR,
    city                    VARCHAR,
    store_code              VARCHAR,
    channel_type            VARCHAR,
    outer_order_no          VARCHAR,
    member_no               VARCHAR,
    member_grade_id         INTEGER,
    member_type             VARCHAR,
    order_item_quantity     INTEGER,
    order_amount            DECIMAL(38, 2),
    order_fact_amount       DECIMAL(38, 2),
    member_register_time    TIMESTAMP,
    last_grade_change_time  TIMESTAMP,
    order_deal_time         TIMESTAMP,
    create_time             TIMESTAMP
);
