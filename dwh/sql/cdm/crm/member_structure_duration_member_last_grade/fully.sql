INSERT INTO cdm_crm.member_structure_duration_member_last_grade (
    computing_until_month,
    computing_duration,
    member_no,
    current_grade_id,
    grade_name,
    grade_code,
    grade_change_time
)
    WITH
        --指定时间段内会员的最新等级
        duration_member_last_grade AS (
            SELECT DISTINCT
            DATE_FORMAT(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
            CAST('{computing_duration}' AS INTEGER)                                     AS computing_duration,
            mgl.member_no,
            mgl.after_grade_id,
            mgi.grade_name,
            mgi.grade_code,
            mgl.grade_change_time
            FROM prod_mysql_crm.crm.member_grade_log mgl
            INNER JOIN ods_crm.order_info oi ON mgl.member_no = oi.member_no
                AND oi.order_deal_time IS NOT NULL
                AND oi.order_deal_time >= date_trunc(
                    'month', DATE('{c_date}') + INTERVAL '-{computing_duration}' MONTH)
                AND oi.order_deal_time < date_trunc(
                'month', DATE('{c_date}'))
            INNER JOIN prod_mysql_crm.crm.member_grade_info mgi ON mgl.after_grade_id = mgi.grade_id
            WHERE 1 > (SELECT COUNT(*)
                    FROM prod_mysql_crm.crm.member_grade_log
                    WHERE member_no = mgl.member_no AND grade_change_time > mgl.grade_change_time)
                AND date_diff('day', mgl.grade_change_time, date_trunc('month', DATE('{c_date}') + INTERVAL '-2' MONTH )) > 0
            ORDER BY mgl.member_no, mgl.grade_change_time DESC
        )
    SELECT *
    FROM duration_member_last_grade;
