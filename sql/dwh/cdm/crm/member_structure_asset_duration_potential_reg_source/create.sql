CREATE SCHEMA IF NOT EXISTS cdm_crm;
DROP TABLE IF EXISTS cdm_crm.member_structure_asset_duration_potential_reg_source;

CREATE TABLE cdm_crm.member_structure_asset_duration_potential_reg_source (
    computing_until_month VARCHAR,
    computing_duration    INTEGER,
    member_no             VARCHAR,
    reg_source            VARCHAR,
    channel_type          VARCHAR,
    sales_area            VARCHAR,
    store_region          VARCHAR
);
