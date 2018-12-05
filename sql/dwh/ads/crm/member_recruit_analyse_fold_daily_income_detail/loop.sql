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
        t.date,
        t.year,
        t.month,
        date_format(t.date, '%Y-%m-%d') AS vchr_date
    FROM ads_crm.member_analyse_daily_income_detail t
    WHERE t.member_type = '会员'
    AND t.date > (SELECT max_date FROM ads_crm.member_analyse_max_date)
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
        t.year,
        t.month,
        t.member_level_type
    
    UNION SELECT DISTINCT
        t1.country,
        t1.sales_area,
        t1.sales_district,
        t1.province,
        t1.city,
        t1.brand_code,
        t1.brand_name,
        t1.store_code,
        t1.sales_mode,
        t1.store_type,
        t1.store_level,
        t1.channel_type,
        t1.order_channel,
        t1.member_upgrade_type AS member_recruit_type,
        NULL                   AS member_register_type,
        array_distinct(flatten(array_agg(t1.customer_array))),
        t1.date,
        t1.year,
        t1.month,
        date_format(t1.date, '%Y-%m-%d') AS vchr_date
    FROM ads_crm.member_analyse_daily_income_detail t1
    WHERE t1.member_type = '会员'
    AND t1.date > (SELECT max_date FROM ads_crm.member_analyse_max_date)
    GROUP BY
        t1.country,
        t1.sales_area,
        t1.sales_district,
        t1.province,
        t1.city,
        t1.brand_code,
        t1.brand_name,
        t1.store_code,
        t1.sales_mode,
        t1.store_type,
        t1.store_level,
        t1.channel_type,
        t1.order_channel,
        t1.date,
        t1.year,
        t1.month,
        t1.member_upgrade_type

    UNION SELECT DISTINCT
        t2.country,
        t2.sales_area,
        t2.sales_district,
        t2.province,
        t2.city,
        t2.brand_code,
        t2.brand_name,
        t2.store_code,
        t2.sales_mode,
        t2.store_type,
        t2.store_level,
        t2.channel_type,
        t2.order_channel,
        NULL                    AS member_recruit_type,
        t2.member_register_type AS member_register_type,
        array_distinct(flatten(array_agg(t2.customer_array))),
        t2.date,
        t2.year,
        t2.month,
        date_format(t2.date, '%Y-%m-%d') AS vchr_date
    FROM ads_crm.member_analyse_daily_income_detail t2
    WHERE t2.member_type = '会员'
    AND t2.date > (SELECT vchr_max_date FROM ads_crm.member_analyse_max_date)
    GROUP BY
        t2.country,
        t2.sales_area,
        t2.sales_district,
        t2.province,
        t2.city,
        t2.brand_code,
        t2.brand_name,
        t2.store_code,
        t2.sales_mode,
        t2.store_type,
        t2.store_level,
        t2.channel_type,
        t2.order_channel,
        t2.date,
        t2.year,
        t2.month,
        t2.member_register_type;
