CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_recruit_analyse_fold_index_label;


CREATE TABLE IF NOT EXISTS ads_crm.member_recruit_analyse_fold_index_label (
    country                 VARCHAR,
    sales_area              VARCHAR,
    sales_district          VARCHAR,
    province                VARCHAR,
    city                    VARCHAR,
    store_code              VARCHAR,
    brand_code              VARCHAR,
    brand_name              VARCHAR,
    member_recruit_type     VARCHAR,
    member_register_type    VARCHAR
);
