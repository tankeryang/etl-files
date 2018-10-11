DELETE FROM ads_crm.member_analyse_fold_daily_income_detail;


INSERT INTO ads_crm.member_analyse_fold_daily_income_detail
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
        t.member_type,
        t.member_newold_type,
        t.member_level_type,
        cast(sum(t.sales_income) AS DECIMAL(18, 3)),
        cast(sum(t.sales_item_quantity) AS INTEGER),
        cast(sum(t.lyst_sales_income) AS DECIMAL(18, 3)),
        array_distinct(flatten(array_agg(t.customer_array))),
        cast(sum(t.order_amount) AS INTEGER),
        t.date
    FROM ads_crm.member_analyse_daily_income_detail t
    GROUP BY DISTINCT
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
        GROUPING SETS (
            (t.member_type),
            (t.member_newold_type),
            (t.member_level_type),
            (t.member_newold_type, t.member_level_type)
        )

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
        '整体' AS member_type,
        NULL AS member_newold_type,
        NULL AS member_level_type,
        cast(sum(t1.sales_income) AS DECIMAL(18, 3)),
        cast(sum(t1.sales_item_quantity) AS INTEGER),
        cast(sum(t1.lyst_sales_income) AS DECIMAL(18, 3)),
        array_distinct(flatten(array_agg(t1.customer_array))),
        cast(sum(t1.order_amount) AS INTEGER),
        t1.date
    FROM ads_crm.member_analyse_daily_income_detail t1
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
        t1.date

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
        NULL AS member_type,
        '会员' AS member_newold_type,
        NULL AS member_level_type,
        cast(sum(t2.sales_income) AS DECIMAL(18, 3)),
        cast(sum(t2.sales_item_quantity) AS INTEGER),
        cast(sum(t2.lyst_sales_income) AS DECIMAL(18, 3)),
        array_distinct(flatten(array_agg(t2.customer_array))),
        cast(sum(t2.order_amount) AS INTEGER),
        t2.date
    FROM ads_crm.member_analyse_daily_income_detail t2
    WHERE t2.member_type = '会员'
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
        t2.date

    UNION SELECT DISTINCT
        t3.country,
        t3.sales_area,
        t3.sales_district,
        t3.province,
        t3.city,
        t3.brand_code,
        t3.brand_name,
        t3.store_code,
        t3.sales_mode,
        t3.store_type,
        t3.store_level,
        t3.channel_type,
        t3.order_channel,
        NULL AS member_type,
        NULL AS member_newold_type,
        '会员' AS member_level_type,
        cast(sum(t3.sales_income) AS DECIMAL(18, 3)),
        cast(sum(t3.sales_item_quantity) AS INTEGER),
        cast(sum(t3.lyst_sales_income) AS DECIMAL(18, 3)),
        array_distinct(flatten(array_agg(t3.customer_array))),
        cast(sum(t3.order_amount) AS INTEGER),
        t3.date
    FROM ads_crm.member_analyse_daily_income_detail t3
    WHERE t3.member_type = '会员'
    GROUP BY
        t3.country,
        t3.sales_area,
        t3.sales_district,
        t3.province,
        t3.city,
        t3.brand_code,
        t3.brand_name,
        t3.store_code,
        t3.sales_mode,
        t3.store_type,
        t3.store_level,
        t3.channel_type,
        t3.order_channel,
        t3.date;
