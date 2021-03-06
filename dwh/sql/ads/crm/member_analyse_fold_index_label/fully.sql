DELETE FROM ads_crm.member_analyse_fold_index_label;


INSERT INTO ads_crm.member_analyse_fold_index_label
    SELECT
        t1.country,
        t1.sales_area,
        t1.sales_district,
        t1.province,
        t1.city,
        t1.store_code,
        t1.brand_code,
        t1.brand_name,
        t2.member_type,
        t2.member_newold_type,
        t2.member_level_type
    FROM (
        SELECT DISTINCT
            country,
            sales_area,
            sales_district,
            province,
            city,
            store_code,
            brand_code,
            brand_name,
            'key' AS key
        FROM ads_crm.member_analyse_daily_income_detail
        WHERE country IS NOT NULL
    ) t1
    FULL JOIN (
        SELECT DISTINCT
            IF(member_type = '', NULL, member_type) AS member_type,
            IF(member_newold_type = '', NULL, member_newold_type) AS member_newold_type,
            IF(member_level_type = '', NULL, member_level_type) AS member_level_type,
            'key' AS key
        FROM ads_crm.member_analyse_daily_income_detail
        UNION SELECT
            '整体' AS member_type,
            NULL  AS member_newold_type,
            NULL  AS member_level_type,
            'key' AS key
        UNION SELECT
            NULL  AS member_type,
            '会员' AS member_newold_type,
            NULL  AS member_level_type,
            'key' AS key
        UNION SELECT
            NULL  AS member_type,
            NULL  AS member_newold_type,
            '会员' AS member_level_type,
            'key' AS key
    ) t2
    ON t1.key = t2.key;
