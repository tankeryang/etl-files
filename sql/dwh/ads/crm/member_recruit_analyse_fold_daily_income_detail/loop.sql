INSERT INTO ads_crm.member_recruit_analyse_fold_daily_income_detail
    SELECT DISTINCT
        t.country,
        t.sales_area,
        t.sales_district,
        t.province,
        t.city,
        t.brand_code,
        t.brand_name,
        t.store_code,
        t.sales_mode,
        t.store_type,
        t.store_level,
        t.channel_type,
        t.order_channel,
        t.member_level_type AS member_recruit_type,
        NULL                AS member_register_type,
        array_distinct(flatten(array_agg(t.customer_array))),
        t.date
    FROM ads_crm.member_analyse_daily_income_detail t
    WHERE t.member_type = '会员'
    AND t.date > (SELECT max(date) FROM ads_crm.member_analyse_daily_income_detail)
    GROUP BY
        t.country,
        t.sales_area,
        t.sales_district,
        t.province,
        t.city,
        t.brand_code,
        t.brand_name,
        t.store_code,
        t.sales_mode,
        t.store_type,
        t.store_level,
        t.channel_type,
        t.order_channel,
        t.date,
        t.member_level_type
    
    UNION SELECT DISTINCT
        t.country,
        t.sales_area,
        t.sales_district,
        t.province,
        t.city,
        t.brand_code,
        t.brand_name,
        t.store_code,
        t.sales_mode,
        t.store_type,
        t.store_level,
        t.channel_type,
        t.order_channel,
        t.member_upgrade_type AS member_recruit_type,
        NULL                  AS member_register_type,
        array_distinct(flatten(array_agg(t.customer_array))),
        t.date
    FROM ads_crm.member_analyse_daily_income_detail t
    WHERE t.member_type = '会员'
    AND t.date > (SELECT max(date) FROM ads_crm.member_analyse_daily_income_detail)
    GROUP BY
        t.country,
        t.sales_area,
        t.sales_district,
        t.province,
        t.city,
        t.brand_code,
        t.brand_name,
        t.store_code,
        t.sales_mode,
        t.store_type,
        t.store_level,
        t.channel_type,
        t.order_channel,
        t.date,
        t.member_upgrade_type

    UNION SELECT DISTINCT
        t.country,
        t.sales_area,
        t.sales_district,
        t.province,
        t.city,
        t.brand_code,
        t.brand_name,
        t.store_code,
        t.sales_mode,
        t.store_type,
        t.store_level,
        t.channel_type,
        t.order_channel,
        NULL                   AS member_recruit_type,
        t.member_register_type AS member_register_type,
        array_distinct(flatten(array_agg(t.customer_array))),
        t.date
    FROM ads_crm.member_analyse_daily_income_detail t
    WHERE t.member_type = '会员'
    GROUP BY
        t.country,
        t.sales_area,
        t.sales_district,
        t.province,
        t.city,
        t.brand_code,
        t.brand_name,
        t.store_code,
        t.sales_mode,
        t.store_type,
        t.store_level,
        t.channel_type,
        t.order_channel,
        t.date,
        t.member_register_type;
