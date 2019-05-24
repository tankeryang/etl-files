DELETE FROM ads_crm.member_grouping_info_detail;


INSERT INTO ads_crm.member_grouping_info_detail
    SELECT DISTINCT
        mi.member_no,
        mi.brand_code,
        DATE_FORMAT(mi.member_birthday, '%m-%d'),
        DATE_FORMAT(mi.member_birthday, '%m'),
        IF(mi.member_gender NOT IN ('男', '女') OR mi.member_gender IS NULL, '其他', mi.member_gender),
        CAST(DATE_DIFF('year', mi.member_birthday, localtimestamp) AS INTEGER),
        CASE
            WHEN mi.member_status = 1 AND mi.member_ec_status = 1 THEN '正常'
            WHEN mi.member_ec_status = -1 THEN '作废'
            WHEN mi.member_status = -1 THEN '异常卡'
            WHEN member_ec_status = 0 THEN '未激活'
        ELSE NULL END,
        DATE(mi.member_register_time),
        CASE
            WHEN mi.store_code IS NULL THEN '其他'
        ELSE mi.store_code END,
        mi.operation_status,
        CASE
            WHEN mi.member_register_store IS NULL THEN '其他'
        ELSE mi.member_register_store END,
        mi.member_reg_source,
        IF(mi.member_mobile IS NOT NULL, 1, 0),
        IF(mi.member_mobile IS NOT NULL, 1, 0),
        IF(mi.member_mobile IS NOT NULL, 1, 0),
        mi.member_grade_id,
        DATE(mi.member_grade_expiration),
        mi.member_score,
        mi.member_will_score,
        DATE(mi.member_last_feedback_time),
        mi.member_last_feedback_time,
        DATE(mi.member_last_grade_change_time),
        mi.member_last_grade_change_time,
        mfc.consumption_date,
        mfc.consumption_gap,
        mfc.store_code,
        mfc.consumption_item_quantity,
        mfc.consumption_amount,
        mfc.consumption_amount_include_coupon,
        mlc.consumption_date,
        mlc.consumption_gap,
        mlc.store_code,
        mlc.consumption_item_quantity,
        mlc.consumption_amount,
        mlc.consumption_amount_include_coupon,
        localtimestamp
    FROM cdm_crm.member_info_detail mi
    LEFT JOIN cdm_crm.member_first_consumption mfc ON mi.member_no = mfc.member_no
        AND mi.brand_code = mfc.brand_code
    LEFT JOIN cdm_crm.member_last_consumption mlc ON mi.member_no = mlc.member_no
        AND mi.brand_code = mlc.brand_code;
