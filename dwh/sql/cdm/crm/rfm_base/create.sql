CREATE SCHEMA IF NOT EXISTS cdm_crm;
DROP TABLE IF EXISTS cdm_crm.rfm_base;

CREATE TABLE cdm_crm.rfm_base (
    rfm_base_id                 INTEGER,
    rfm_conf_dimension_first    INTEGER,
    rfm_conf_dimension_second   INTEGER,
    computing_duration          INTEGER,
    computing_until_month       VARCHAR,
    member_count                BIGINT,
    order_count                 BIGINT,
    member_spent                DECIMAL(38, 2),
    create_time                 TIMESTAMP
);
