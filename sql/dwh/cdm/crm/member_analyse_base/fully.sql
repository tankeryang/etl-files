DELETE FROM cdm_crm.member_analyse_base;


INSERT INTO cdm_crm.member_analyse_base
    SELECT
        si.country,
        si.sales_area,
        cms_si.management_district_code,
        IF(oi.order_from = '1', '线上', '线下'),
        si.province,
        si.city,
        si.brand_code,
        oi.store_code,
        (CASE cms_si.sales_mode
        WHEN 'ZJ' THEN '正价'
        WHEN 'QCT' THEN '长特'
        WHEN 'BCT' THEN '长特'
        WHEN 'DT' THEN '短特'
        ELSE NULL END),
        (CASE si.store_type
        WHEN 'BH' THEN '百货'
        WHEN 'ZMD' THEN '专卖店'
        WHEN 'MALL' THEN 'MALL'
        ELSE NULL END),
        cms_si.store_level,
        si.channel_type,
        oi.outer_order_no,
        oi.member_no,
        oi.order_grade,
        -- 整体字段
        '整体',
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
        oi.order_item_quantity,
        oi.order_amount,
        oi.order_fact_amount,
        mi.member_register_time,
        IF(oi.member_no != '-1', mgl.grade_change_time, NULL),
        oi.order_deal_time,
        localtimestamp
    FROM
        ods_crm.order_info oi
    LEFT JOIN
        ods_crm.store_info si
    ON
        oi.store_code = si.store_code
    LEFT JOIN
        ods_cms.store_info cms_si
    ON
        si.store_code = cms_si.store_code
    LEFT JOIN
        cdm_crm.member_first_order mfo
    ON
        oi.member_no = mfo.member_no
    LEFT JOIN
        ods_crm.member_info mi
    ON
        oi.member_no = mi.member_no
    LEFT JOIN (
        SELECT
            oi_t.member_no,
            oi_t.outer_order_no,
            oi_t.order_deal_time,
            max(mgl_t.grade_change_time)  grade_change_time
        FROM
            ods_crm.order_info oi_t
        LEFT JOIN
            ods_crm.member_grade_log mgl_t
        ON
            oi_t.member_no = mgl_t.member_no
            AND date_format(oi_t.order_deal_time, '%Y-%m-%d') >= date_format(mgl_t.grade_change_time, '%Y-%m-%d')
        GROUP BY
            oi_t.member_no,
            oi_t.outer_order_no,
            oi_t.order_deal_time
    ) mgl
    ON
        oi.member_no = mgl.member_no
        AND oi.outer_order_no = mgl.outer_order_no
        AND oi.order_deal_time = mgl.order_deal_time
  WHERE
        date_format(oi.order_deal_time, '%Y-%m-%d %T') <= date_format(localtimestamp, '%Y-%m-%d %T');
