CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_cumulative_consumption_max_date;


CREATE TABLE IF NOT EXISTS ads_crm.member_cumulative_consumption_max_date (
    max_date      DATE,
    vchr_max_date VARCHAR,
    last_month    VARCHAR
) WITH (format = 'ORC');
