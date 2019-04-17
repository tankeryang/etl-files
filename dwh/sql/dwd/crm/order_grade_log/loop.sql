DELETE FROM dwd_crm.order_grade_log;


INSERT INTO dwd_crm.order_grade_log
    SELECT DISTINCT
        oi.member_no,
        oi.brand_code                                                      AS brand_code,
        oi.outer_order_no                                                  AS outer_order_no,
        IF(after_grade_id > before_grade_id AND mgl.before_grade_id IN (5, 9, 13)
            AND mgl.before_grade_id IS NOT NULL AND mgl.after_grade_id IS NOT NULL,
            CAST(1 AS TINYINT), CAST(0 AS TINYINT))                        AS is_normal_upgrade,
        IF(after_grade_id > before_grade_id
            AND mgl.before_grade_id IS NOT NULL AND mgl.after_grade_id IS NOT NULL,
            CAST(1 AS TINYINT), CAST(0 AS TINYINT))                        AS is_upgrade,
        mgl.before_grade_id                                                AS before_grade_id,
        CASE mgl.before_grade_id
            WHEN 5 THEN '普通会员'
            WHEN 9 THEN '普通会员'
            WHEN 13 THEN '普通会员'
            WHEN 6 THEN '银卡会员'
            WHEN 10 THEN '银卡会员'
            WHEN 14 THEN 'VIP会员'
            WHEN 44 THEN 'SVIP会员'
            WHEN 7 THEN '金卡会员'
            WHEN 11 THEN '金卡会员'
            WHEN 8 THEN '黑卡会员'
        ELSE NULL END                                                      AS before_grade_name,
        mgl.after_grade_id                                                 AS after_grade_id,
        CASE mgl.after_grade_id
            WHEN 5 THEN '普通会员'
            WHEN 9 THEN '普通会员'
            WHEN 13 THEN '普通会员'
            WHEN 6 THEN '银卡会员'
            WHEN 10 THEN '银卡会员'
            WHEN 14 THEN 'VIP会员'
            WHEN 44 THEN 'SVIP会员'
            WHEN 7 THEN '金卡会员'
            WHEN 11 THEN '金卡会员'
            WHEN 8 THEN '黑卡会员'
        ELSE NULL END                                                      AS after_grade_name,
        mgl.grade_change_time                                              AS grade_change_time,
        oi.order_deal_time                                                 AS order_deal_time,
        oi.order_deal_date                                                 AS order_deal_date,
        oi.order_deal_year_month                                           AS order_deal_year_month,
        oi.order_deal_year                                                 AS order_deal_year,
        oi.order_deal_month                                                AS order_deal_month,
        oi.create_time                                                     AS create_time
    FROM dwd_crm.order_info oi
    LEFT JOIN ods_crm.member_grade_log mgl
    ON oi.member_no = mgl.member_no
        AND oi.brand_code = mgl.brand_code
        AND oi.outer_order_no = mgl.outer_order_no
    WHERE oi.member_no > '0'
        AND oi.create_time > (SELECT MAX(create_time) FROM dwd_crm.order_grade_log)
        AND oi.create_time < DATE_PARSE(DATE_FORMAT(localtimestamp, '%Y-%m-%d 00:00:00'), '%Y-%m-%d %T');
