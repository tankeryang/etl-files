CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.order_info_detail_max_date;


CREATE TABLE IF NOT EXISTS ads_crm.order_info_detail_max_date (
    max_date      DATE,
    vchr_max_date VARCHAR,
    last_month    VARCHAR
) WITH (format = 'ORC');
