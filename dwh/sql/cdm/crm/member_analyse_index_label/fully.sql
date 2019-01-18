DELETE FROM cdm_crm.member_analyse_index_label;


INSERT INTO cdm_crm.member_analyse_index_label
    SELECT
        t1.country,
        t1.sales_area,
        t1.sales_district,
        t1.order_channel,
        t1.province,
        t1.city,
        t1.store_code,
        t1.brand_code,
        t1.brand_name,
        t1.sales_mode,
        t1.store_type,
        t1.store_level,
        t1.channel_type,
        t2.member_type,
        t3.member_nowbefore_type,
        t2.member_newold_type,
        t2.member_level_type,
        t2.dr_member_type
    FROM (
        SELECT DISTINCT
            country,
            sales_area,
            sales_district,
            order_channel,
            province,
            city,
            store_code,
            brand_code,
            brand_name,
            sales_mode,
            store_type,
            store_level,
            channel_type,
            'key' AS key
        FROM cdm_crm.order_info_detail
        WHERE country IS NOT NULL
    ) t1
    FULL JOIN (
        SELECT DISTINCT
            member_type,
            member_newold_type,
            member_level_type,
            dr_member_type,
            'key' AS key
        FROM cdm_crm.order_info_detail
    ) t2
    ON t1.key = t2.key
    FULL JOIN (
        SELECT '当月会员' AS member_nowbefore_type, 'key' AS key
        UNION SELECT '当年会员' AS member_nowbefore_type, 'key' AS key
        UNION SELECT '往年会员' AS member_nowbefore_type, 'key' AS key
    ) t3
    ON t1.key = t3.key

    UNION SELECT
        tt1.country,
        tt1.sales_area,
        tt1.sales_district,
        tt4.order_channel,
        tt1.province,
        tt1.city,
        NULL AS store_code,
        tt1.brand_code,
        tt1.brand_name,
        tt4.sales_mode,
        tt4.store_type,
        tt4.store_level,
        tt4.channel_type,
        tt2.member_type,
        tt3.member_nowbefore_type,
        tt2.member_newold_type,
        tt2.member_level_type,
        tt2.dr_member_type
    FROM (
        SELECT DISTINCT
            country,
            sales_area,
            sales_district,
            province,
            city,
            brand_code,
            brand_name,
            'key' AS key
        FROM cdm_crm.order_info_detail
        WHERE country IS NOT NULL
    ) tt1
    FULL JOIN (
        SELECT DISTINCT
            sales_mode,
            store_type,
            store_level,
            channel_type,
            order_channel,
            'key' AS key
        FROM cdm_crm.order_info_detail
        WHERE sales_mode IS NOT NULL
        AND store_type IS NOT NULL
        AND store_level IS NOT NULL
        AND channel_type IS NOT NULL
        AND order_channel IS NOT NULL
    ) tt4
    ON tt1.key = tt4.key
    FULL JOIN (
        SELECT DISTINCT
            member_type,
            member_newold_type,
            member_level_type,
            dr_member_type,
            'key' AS key
        FROM cdm_crm.order_info_detail
    ) tt2
    ON tt1.key = tt2.key
    FULL JOIN (
        SELECT '当月会员' AS member_nowbefore_type, 'key' AS key
        UNION SELECT '当年会员' AS member_nowbefore_type, 'key' AS key
        UNION SELECT '往年会员' AS member_nowbefore_type, 'key' AS key
    ) tt3
    ON tt1.key = tt3.key;
