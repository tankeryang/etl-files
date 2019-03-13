DELETE FROM ods_crm.member_grade_log;


INSERT INTO ods_crm.member_grade_log
    SELECT DISTINCT
        log_id,
        brand_code,
        member_no,
        outer_order_no,
        member_grade_order_no,
        before_grade_id,
        after_grade_id,
        event_code,
        change_reason,
        change_reason_desc,
        store_no,
        clerk_no,
        grade_change_time,
        trigger_order_id,
        grade_expiration,
        grade_begin,
        create_user,
        create_time,
        status
    FROM prod_mysql_crm.crm.member_grade_log
    WHERE create_time < DATE_PARSE(DATE_FORMAT(localtimestamp, '%Y-%m-%d 00:00:00'), '%Y-%m-%d %T')
        AND brand_code IN ('2', '3', '6');
