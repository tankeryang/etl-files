CREATE SCHEMA IF NOT EXISTS cdm_crm;


DROP TABLE IF EXISTS cdm_crm.rfm_base_with_expression;


CREATE TABLE cdm_crm.rfm_base_with_expression (
    horizon_type              VARCHAR,
    horizon_expression        VARCHAR,
    horizon_type_range        VARCHAR,
    rfm_base_id               INTEGER,
    rfm_conf_dimension_first  INTEGER,
    rfm_conf_dimension_second INTEGER,
    computing_duration        INTEGER,
    computing_until_month     VARCHAR,
    member_count              BIGINT,
    order_count               BIGINT,
    member_spent              DECIMAL(38, 2),
    create_time               TIMESTAMP,
    vertical_type             VARCHAR,
    vertical_expression       VARCHAR,
    vertical_type_range       VARCHAR
) WITH (format = 'ORC');