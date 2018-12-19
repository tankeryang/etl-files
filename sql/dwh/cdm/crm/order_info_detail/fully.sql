DELETE FROM cdm_crm.order_info_detail;


INSERT INTO cdm_crm.order_info_detail
    WITH mgl AS (
        SELECT
            oi_t.member_no,
            oi_t.brand_code,
            oi_t.outer_order_no,
            oi_t.order_deal_time,
            max(mgl_t.grade_change_time) AS grade_change_time
        FROM ods_crm.order_info oi_t
        LEFT JOIN dev_mysql_fpsit.crm.member_grade_log mgl_t
        ON oi_t.member_no = mgl_t.member_no
        AND oi_t.brand_code = mgl_t.brand_code
        AND date_format(oi_t.order_deal_time, '%Y-%m-%d') >= date_format(mgl_t.grade_change_time, '%Y-%m-%d')
        GROUP BY oi_t.member_no, oi_t.brand_code, oi_t.outer_order_no, oi_t.order_deal_time
    ), cdm_cms_si_bn AS (
        SELECT DISTINCT brand_code, brand_name FROM cdm_cms.store_info
    )
    SELECT
        IF(cdm_cms_si.country_name IS NULL, '', cdm_cms_si.country_name)  AS country,
        IF(si.sales_area IS NULL, '', si.sales_area)                      AS sales_area,
        IF(cms_si.management_district_code IS NULL, '', cms_si.management_district_code) AS sales_district,
        IF(oi.order_from = '1', '线上', '线下')                AS order_channel,
        IF(oi.trade_source IS NULL, '', 
            CASE
                WHEN oi.trade_source = 'OMIS' THEN 'OMIS'
                WHEN oi.trade_source = 'fpos' THEN 'FPOS'
                WHEN oi.trade_source LIKE '%ipos%' THEN 'IPOS'
                WHEN oi.trade_source = 'web' THEN '官网'
                WHEN oi.trade_source = 'wap' THEN '官网'
                WHEN oi.trade_source = 'weixin' THEN '官网'
                WHEN oi.trade_source = 'mobile' THEN '官网'
            ELSE '其他' END)                                   AS trade_source,
        IF(si.province IS NULL, '', si.province)              AS province,
        IF(si.city IS NULL, '', si.city)                      AS city,
        oi.brand_code                                         AS brand_code,
        cdm_cms_si_bn.brand_name                              AS brand_name,
        oi.store_code                                         AS store_code,
        CASE cms_si.sales_mode
            WHEN 'ZJ' THEN '正价'
            WHEN 'QCT' THEN '长特'
            WHEN 'BCT' THEN '长特'
            WHEN 'DT' THEN '短特'
        ELSE '' END                                           AS sales_mode,
        CASE si.store_type
            WHEN 'BH' THEN '百货'
            WHEN 'ZMD' THEN '专卖店'
            WHEN 'MALL' THEN 'MALL'
        ELSE '' END                                           AS store_type,
        IF (cms_si.store_level = '' OR cms_si.store_level IS NULL, '',
            IF(cms_si.store_level IN ('C', 'C+', 'C-'), 'C', cms_si.store_level)
        )                                                     AS store_level,
        IF (si.channel_type IS NULL, '', si.channel_type)     AS channel_type,
        oi.outer_order_no                                     AS outer_order_no,
        oi.member_no                                          AS member_no,
        oi.order_grade                                        AS member_grade_id,
        -- 是否会员
        IF(COALESCE(try_cast(oi.member_no AS INTEGER), 0) > 0, '会员', '非会员')  AS member_type,
        -- 新老会员分析
        IF(COALESCE(try_cast(oi.member_no AS INTEGER), 0) > 0,
            IF(date_format(oi.order_deal_time, '%Y-%m-%d') <= date_format(mfo.order_deal_time, '%Y-%m-%d'),
                '新会员',
                '老会员'
        ), NULL)                                              AS member_newold_type,
        -- 会员等级分析
        IF(COALESCE(try_cast(oi.member_no AS INTEGER), 0) > 0,
            (CASE oi.order_grade
                WHEN 13 THEN '普通会员'
                WHEN 9 THEN '普通会员'
                WHEN 14 THEN 'VIP会员'
                WHEN 10 THEN 'VIP会员'
                WHEN 11 THEN 'VIP会员'
            ELSE NULL END
        ), NULL)                                               AS member_level_type,
        -- 会员升级类型
        IF(COALESCE(try_cast(oi.member_no AS INTEGER), 0) > 0,
            IF(oi.order_grade IN (13, 9) AND date(mgl.grade_change_time) = date(oi.order_deal_time),
                '升级', '未升级'
        ), NULL)                                               AS member_upgrade_type,
        -- 会员注册类型
        IF(COALESCE(try_cast(oi.member_no AS INTEGER), 0) > 0, 
            IF(mi.member_manage_store like '%WWW%', '官网', '门店'
        ), NULL)                                               AS member_register_type,
        -- 招募会员-有消费会员类型
        IF(COALESCE(try_cast(oi.member_no AS INTEGER), 0) > 0,
            IF(oi.order_grade IN (13, 9) AND date(mgl.grade_change_time) = date(oi.order_deal_time),
                '升级', CASE oi.order_grade
                WHEN 13 THEN '普通会员'
                WHEN 9 THEN '普通会员'
                WHEN 14 THEN 'VIP会员'
                WHEN 10 THEN 'VIP会员'
                WHEN 11 THEN 'VIP会员'
            ELSE NULL END
        ), NULL)                                               AS member_recruit_type,
        -- 日报会员类型
        IF(COALESCE(try_cast(oi.member_no AS INTEGER), 0) > 0 AND oi.order_grade IN (9, 10, 11, 13, 14),
            IF(date_format(oi.order_deal_time, '%Y-%m-%d') <= date_format(mfo.order_deal_time, '%Y-%m-%d'),
                '新会员',
                CASE oi.order_grade
                WHEN 13 THEN '普通会员'
                WHEN 9 THEN '普通会员'
                WHEN 14 THEN 'VIP会员'
                WHEN 10 THEN 'VIP会员'
                WHEN 11 THEN 'VIP会员'
                ELSE NULL END), '非会员'
        )                                                      AS dr_member_type,
        oi.order_item_quantity                                 AS order_item_quantity,
        oi.order_amount                                        AS order_amount,
        oi.order_fact_amount                                   AS order_fact_amount,
        cast(IF(oi.order_fact_amount > 0, 
            oi.order_fact_amount - COALESCE(ocid.coupon_denomination_sum, 0),
            oi.order_fact_amount) AS DECIMAL(38, 2))           AS order_fact_amount_include_coupon,
        ocid.pay_type                                          AS order_pay_type,
        CASE
            WHEN oi.order_fact_amount > 0 THEN 1
            WHEN oi.order_fact_amount = 0 THEN 0
            WHEN oi.order_fact_amount < 0 THEN -1
        ELSE NULL END                                          AS order_type_num,
        ocid.coupon_no_array                                   AS order_coupon_no,
        ocid.coupon_category                                   AS order_coupon_category,
        ocid.coupon_denomination_sum                           AS order_coupon_denomination,
        mi.member_register_time                                AS member_register_time,
        IF(COALESCE(try_cast(oi.member_no AS INTEGER), 0) > 0,
            mgl.grade_change_time, NULL)                       AS last_grade_change_time,
        oi.order_deal_time                                     AS order_deal_time,
        date(oi.order_deal_time)                               AS order_deal_date,
        localtimestamp                                         AS create_time
    FROM ods_crm.order_info oi
    LEFT JOIN cdm_crm.order_coupon_info_detail ocid ON oi.outer_order_no = ocid.outer_order_no
        AND ocid.coupon_category = 'Cash'
    LEFT JOIN ods_crm.store_info si ON oi.store_code = si.store_code
    LEFT JOIN ods_cms.store_info cms_si ON oi.store_code = cms_si.store_code
    LEFT JOIN cdm_cms.store_info cdm_cms_si ON cdm_cms_si.country_code = cms_si.country_code
        AND cdm_cms_si.store_code = oi.store_code
    LEFT JOIN cdm_cms_si_bn ON oi.brand_code = cdm_cms_si_bn.brand_code
    LEFT JOIN cdm_crm.member_first_order mfo ON oi.member_no = mfo.member_no AND oi.brand_code = mfo.brand_code
    LEFT JOIN ods_crm.member_info mi ON oi.member_no = mi.member_no AND oi.brand_code = mi.brand_code
    LEFT JOIN mgl ON oi.member_no = mgl.member_no
        AND oi.brand_code = mgl.brand_code
        AND oi.outer_order_no = mgl.outer_order_no
        AND oi.order_deal_time = mgl.order_deal_time
    WHERE oi.order_status = 'PAYED'
    AND date(oi.order_deal_time) < date(localtimestamp);
