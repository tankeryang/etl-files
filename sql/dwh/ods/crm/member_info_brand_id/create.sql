CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.member_info_brand_id;


CREATE TABLE ods_crm.member_info_brand_id (
    member_no  VARCHAR,
    brand_code VARCHAR,
    brand_id   INTEGER
);
