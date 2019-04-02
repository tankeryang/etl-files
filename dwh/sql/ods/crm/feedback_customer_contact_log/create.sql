CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.feedback_customer_contact_log;


CREATE TABLE IF NOT EXISTS ods_crm.feedback_customer_contact_log (
    contact_log_id           INTEGER,
    clerk_id                 VARCHAR,
    member_no                VARCHAR,
    feedback_intention       INTEGER,
    feedback_time            TIMESTAMP,
    store_code               VARCHAR,
    after_shopping_count     INTEGER,
    about_to_upgrade_count   INTEGER,
    about_to_downgrade_count INTEGER,
    birthday_count           INTEGER,
    get_coupon_count         INTEGER,
    activity_decline_count   INTEGER,
    clerk_task_count         INTEGER,
    contact_desc             VARCHAR,
    brand_code               VARCHAR,
    feedback_way             VARCHAR,
    create_time              TIMESTAMP
) WITH (format = 'ORC');
