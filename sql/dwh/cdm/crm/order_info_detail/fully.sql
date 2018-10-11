DELETE FROM cdm_crm.order_info_detail;


INSERT INTO cdm_crm.order_info_detail
    WITH mgl AS (
        SELECT
            oi_t.member_no,
            oi_t.outer_order_no,
            oi_t.order_deal_time,
            max(mgl_t.grade_change_time)  grade_change_time
        FROM ods_crm.order_info oi_t
        LEFT JOIN ods_crm.member_grade_log mgl_t
        ON oi_t.member_no = mgl_t.member_no
        AND date_format(oi_t.order_deal_time, '%Y-%m-%d') >= date_format(mgl_t.grade_change_time, '%Y-%m-%d')
        GROUP BY oi_t.member_no, oi_t.outer_order_no, oi_t.order_deal_time
    )
    SELECT
        cdm_cms_si.country_name,
        si.sales_area,
        cms_si.management_district_code,
        IF(oi.order_from = '1', '线上', '线下'),
        si.province,
        si.city,
        si.brand_code,
        cdm_cms_si.brand_name,
        oi.store_code,
        CASE cms_si.sales_mode
            WHEN 'ZJ' THEN '正价'
            WHEN 'QCT' THEN '长特'
            WHEN 'BCT' THEN '长特'
            WHEN 'DT' THEN '短特'
        ELSE NULL END,
        CASE si.store_type
            WHEN 'BH' THEN '百货'
            WHEN 'ZMD' THEN '专卖店'
            WHEN 'MALL' THEN 'MALL'
        ELSE NULL END,
        IF(cms_si.store_level = '', NULL, IF(cms_si.store_level IN ('C', 'C+', 'C-'), 'C', cms_si.store_level)),
        si.channel_type,
        oi.outer_order_no,
        oi.member_no,
        oi.order_grade,
        -- 会员与非会员
        IF(oi.member_no NOT IN ('-1', '-2'), '会员', '非会员'),
        -- 新老会员类型
        IF(oi.member_no NOT IN ('-1', '-2'),
            IF(date_format(oi.order_deal_time, '%Y-%m-%d') <= date_format(mfo.order_deal_time, '%Y-%m-%d'),
                '新会员',
                '老会员'
        ),NULL),
        -- 会员等级分析
        IF(oi.member_no NOT IN ('-1', '-2'), 
        (CASE oi.order_grade
        WHEN 13 THEN '普通会员'
        WHEN 14 THEN 'VIP会员'
        ELSE NULL END), NULL),
        -- 会员升级类型
        IF(((oi.member_no NOT IN ('-1', '-2') AND oi.order_grade = 13)
                OR (oi.member_no NOT IN ('-1', '-2') AND date_format(oi.order_deal_time, '%Y-%m-%d') <= date_format(mfo.order_deal_time, '%Y-%m-%d')))
            AND date(mgl.grade_change_time) = date(oi.order_deal_time),
            '升级', '未升级'),
        IF(oi.member_no NOT IN ('-1', '-2') AND mi.member_manage_store like '%WWW%',
            '官网', '门店'),
        cast(IF(oi.member_no NOT IN ('-1', '-2'),
            IF(date_format(oi.order_deal_time, '%Y-%m-%d') <= date_format(mfo.order_deal_time, '%Y-%m-%d'),
                '新会员',
                CASE oi.order_grade
                WHEN 13 THEN '普通会员'
                WHEN 14 THEN 'VIP会员'
                ELSE NULL END),
            '非会员') AS VARCHAR),
        oi.order_item_quantity,
        oi.order_amount,
        oi.order_fact_amount,
        mi.member_register_time,
        IF(oi.member_no != '-1', mgl.grade_change_time, NULL),
        oi.order_deal_time,
        localtimestamp
    FROM ods_crm.order_info oi
    LEFT JOIN ods_crm.store_info si ON oi.store_code = si.store_code
    LEFT JOIN ods_cms.store_info cms_si ON oi.store_code = cms_si.store_code
    LEFT JOIN cdm_cms.store_info cdm_cms_si ON cdm_cms_si.country_code = cms_si.country_code
        AND cdm_cms_si.store_code = oi.store_code 
    LEFT JOIN cdm_crm.member_first_order mfo ON oi.member_no = mfo.member_no
    LEFT JOIN ods_crm.member_info mi ON oi.member_no = mi.member_no
    LEFT JOIN mgl ON oi.member_no = mgl.member_no
        AND oi.outer_order_no = mgl.outer_order_no
        AND oi.order_deal_time = mgl.order_deal_time
    WHERE oi.order_status = 'PAYED'
    AND oi.order_id NOT IN (60754226, 61380230)
    AND date_format(oi.order_deal_time, '%Y-%m-%d %T') <= date_format(localtimestamp, '%Y-%m-%d %T');
