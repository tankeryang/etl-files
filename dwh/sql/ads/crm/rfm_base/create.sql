CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.rfm_base;


CREATE TABLE ads_crm.rfm_base (
    rfm_id                     BIGINT,
    horizon_type               VARCHAR,
    vertical_type              VARCHAR,
    horizon_type_range         VARCHAR,
    vertical_type_range        VARCHAR,
    horizon_expression         VARCHAR,
    vertical_expression        VARCHAR,
    computing_duration         INTEGER,
    computing_until_month      VARCHAR,
    member_count               BIGINT,
    member_percentage          DECIMAL(38, 4),
    order_count                BIGINT,
    member_spent               DECIMAL(38, 2),
    monetary_per_order         DECIMAL(38, 2),
    order_count_per_member     DECIMAL(38, 2),
    monetary_per_member        DECIMAL(38, 2),
    create_time                TIMESTAMP,
    vchr_computing_until_month VARCHAR,
) WITH (partitioned_by = array['vchr_computing_until_month']);
