INSERT INTO ods_crm.feedback_customer_contact_log
    SELECT
        contact_log_id,
        clerk_id,
        user_id,
        feedback_intention,
        feedback_time,
        store_code,
        after_shopping_count,
        about_to_upgrade_count,
        about_to_downgrade_count,
        birthday_count,
        get_coupon_count,
        activity_decline_count,
        clerk_task_count,
        contact_desc,
        brand_code,
        feedback_way,
        localtimestamp
    FROM prod_mysql_crm.crm.feedback_customer_contact_log
    WHERE feedback_time < DATE_PARSE(DATE_FORMAT(localtimestamp, '%Y-%m-%d 00:00:00'), '%Y-%m-%d %T')
        AND feedback_time > (SELECT MAX(feedback_time) FROM ods_crm.feedback_customer_contact_log)
        AND brand_code IN ('2', '3', '6');
