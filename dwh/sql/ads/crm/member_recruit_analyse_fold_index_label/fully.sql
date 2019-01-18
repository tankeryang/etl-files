DELETE FROM ads_crm.member_recruit_analyse_fold_index_label;


INSERT INTO ads_crm.member_recruit_analyse_fold_index_label
    SELECT
        t1.country,
        t1.sales_area,
        t1.sales_district,
        t1.province,
        t1.city,
        t1.store_code,
        t1.brand_code,
        t1.brand_name,
        t2.member_recruit_type,
        t2.member_register_type
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
        FROM cdm_crm.order_info_detail
        WHERE country IS NOT NULL
    ) t1
    FULL JOIN (
        SELECT DISTINCT
            member_recruit_type,
            member_register_type,
            'key' AS key
        FROM cdm_crm.order_info_detail
    ) t2
    ON t1.key = t2.key;
