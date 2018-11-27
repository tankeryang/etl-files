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
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE country IS NOT NULL
    ) t1
    FULL JOIN (
        SELECT DISTINCT
            member_type,
            member_newold_type,
            member_level_type,
            'key' AS key
        FROM ads_crm.member_analyse_fold_daily_income_detail
    ) t2
    ON t1.key = t2.key;
