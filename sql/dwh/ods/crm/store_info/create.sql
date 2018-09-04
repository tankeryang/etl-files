CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.store_info;


CREATE TABLE ods_crm.store_info (
    store_id         INTEGER,
    store_code       VARCHAR,
    store_name       VARCHAR,
    channel_type     VARCHAR,
    store_type       VARCHAR,
    operation_state  VARCHAR,
    brand_code       VARCHAR,
    business_mode    VARCHAR,
    country          VARCHAR,
    sales_area       VARCHAR,
    province         VARCHAR,
    city             VARCHAR,
    district         VARCHAR,
    create_time      TIMESTAMP
);
