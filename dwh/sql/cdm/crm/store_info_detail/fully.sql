DELETE FROM cdm_crm.store_info_detail;


INSERT INTO cdm_crm.store_info_detail
    SELECT
        si.store_code,
        si.store_name,
        si.channel_type,
        si.store_type,
        IF(cms_si.store_level = '无' OR cms_si.store_level IS NULL,
            '', IF(cms_si.store_level IN ('C', 'C+', 'C-'),
                'C', cms_si.store_level))                             AS store_level,
        cms_si.sales_mode_simple_name,
        si.operation_state,
        si.brand_code,
        si.business_mode,
        si.country,
        IF(cms_si.country_name IS NULL, '', cms_si.country_name)      AS cms_country,
        si.province,
        si.sales_area,
        IF(cms_si.management_district = '无' OR cms_si.management_district IS NULL,
            '', cms_si.management_district)                           AS sales_district,
        si.city,
        si.district,
        cms_si.company_name,
        LOCALTIMESTAMP
    FROM ods_crm.store_info si
    LEFT JOIN cdm_cms.cms_store cms_si ON si.store_code = cms_si.store_code;
