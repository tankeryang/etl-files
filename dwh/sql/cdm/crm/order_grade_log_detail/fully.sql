DELETE FROM cdm_crm.order_grade_log_detail;


INSERT INTO cdm_crm.order_grade_log_detail
    SELECT DISTINCT
        oi.member_no,
        oi.brand_code                                                      AS brand_code,
        oi.outer_order_no                                                  AS outer_order_no,
        oi.order_deal_time                                                 AS order_deal_time,
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
        IF(COALESCE(TRY_CAST(oi.member_no AS INTEGER), 0) > 0,
            IF(after_grade_id > before_grade_id AND mgl.before_grade_id IN (5, 9, 13)
                AND mgl.before_grade_id IS NOT NULL AND mgl.after_grade_id IS NOT NULL, '升级', '未升级'
                ), NULL)                                                   AS normal_upgrade_type,
        IF(COALESCE(TRY_CAST(oi.member_no AS INTEGER), 0) > 0,
            IF(after_grade_id > before_grade_id
                AND mgl.before_grade_id IS NOT NULL AND mgl.after_grade_id IS NOT NULL, '升级', '未升级'
                ), NULL)                                                   AS upgrade_type
    FROM ods_crm.order_info oi
    LEFT JOIN ods_crm.member_grade_log mgl
    ON oi.member_no = mgl.member_no
        AND oi.brand_code = mgl.brand_code
        AND oi.outer_order_no = mgl.outer_order_no;
