CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.cic_main_page;


CREATE TABLE IF NOT EXISTS ads_crm.cic_main_page(
    brand                  VARCHAR,
    register_member_amount INTEGER,
    rma_compared_with_ydst DECIMAL(18, 4),
    rma_compared_with_lwst DECIMAL(18, 4),
    rma_compared_with_lmst DECIMAL(18, 4)
);
