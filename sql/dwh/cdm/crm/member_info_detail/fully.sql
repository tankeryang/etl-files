DELETE FROM cdm_crm.member_info_detail;


INSERT INTO cdm_crm.member_info_detail
    SELECT
        mi.member_no                     AS member_no,
        cdm_cms_si.brand_code            AS brand_code,
        cdm_cms_si.brand_name            AS brand_name,
        cdm_cms_si.country_name          AS country,
        si.sales_area                    AS sales_area,
        cms_si.management_district_code  AS sales_district,
        si.province                      AS province,
        si.city                          AS city,
        mi.member_manage_store           AS store_code,
        cdm_cms_si.store_name            AS store_name,
        (CASE cms_si.sales_mode
        WHEN 'ZJ' THEN '正价'
        WHEN 'QCT' THEN '长特'
        WHEN 'BCT' THEN '长特'
        WHEN 'DT' THEN '短特'
        ELSE NULL END)                   AS sales_mode,
        (CASE si.store_type
        WHEN 'BH' THEN '百货'
        WHEN 'ZMD' THEN '专卖店'
        WHEN 'MALL' THEN 'MALL'
        ELSE NULL END)                   AS store_type,
        cms_si.store_level               AS store_level,
        si.channel_type                  AS channel_type,
        mi.member_wechat_id              AS member_wechat_id,
        mi.member_taobao_nick            AS member_taobao_nick,
        mi.member_code                   AS member_code,
        mi.member_card                   AS member_card,
        mi.member_name                   AS member_name,
        mi.member_nick_name              AS member_nick_name,
        mi.member_birthday               AS member_birthday,
        mi.member_gender                 AS member_gender,
        mi.member_phone                  AS member_phone,
        mi.member_mobile                 AS member_mobile,
        mi.member_email                  AS member_email,
        mi.member_reg_source             AS member_reg_source,
        mi.member_register_store         AS member_register_store,
        mi.member_register_time          AS member_register_time,
        mi.member_grade_id               AS member_grade_id,
        mi.member_grade_begin            AS member_grade_begin,
        mi.member_grade_expiration       AS member_grade_expiration,
        mi.member_score                  AS member_score,
        mi.member_will_score             AS member_will_score,
        mi.member_coupon_denomination    AS member_coupon_denomination,
        mfo.order_deal_time              AS member_first_order_time,
        mlo.order_deal_time              AS member_last_order_time,
        mi.member_status                 AS member_status,
        mi.member_ec_status              AS member_ec_status,
        mi.modify_time                   AS modify_time,
        localtimestamp                   AS create_time
    FROM ods_crm.member_info mi
    LEFT JOIN cdm_cms.store_info cdm_cms_si ON cdm_cms_si.store_code = mi.member_manage_store
    LEFT JOIN ods_crm.store_info si ON mi.member_manage_store = si.store_code
    LEFT JOIN ods_cms.store_info cms_si ON mi.member_manage_store = cms_si.store_code
    LEFT JOIN cdm_crm.member_first_order mfo ON mi.member_no = mfo.member_no AND mfo.brand_code = cdm_cms_si.brand_code
    LEFT JOIN cdm_crm.member_last_order mlo ON mi.member_no = mlo.member_no AND mlo.brand_code = cdm_cms_si.brand_code;
