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
        t.trade_source,
        t.member_type,
        IF(t.member_newold_type = '', NULL, t.member_newold_type) AS member_newold_type,
        IF(t.member_level_type = '', NULL, t.member_level_type) AS member_level_type,
        CAST(SUM(t.sales_income) AS DECIMAL(18, 3)),
        CAST(SUM(t.sales_item_quantity) AS INTEGER),
        CAST(SUM(t.lyst_sales_income) AS DECIMAL(18, 3)),
        ARRAY_DISTINCT(FLATTEN(ARRAY_AGG(t.customer_array))),
        CAST(SUM(t.order_amount) AS INTEGER),
        t.date,
        concat(t.year, '-', t.month) AS year_month,
        DATE_FORMAT(t.date, '%Y-%m-%d') AS vchr_date
    FROM ads_crm.member_analyse_daily_income_detail t
    WHERE t.date > (SELECT max_date FROM ads_crm.member_analyse_max_date)
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
        t.trade_source,
        t.date,
        t.year,
        t.month,
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
        t1.trade_source,
        '整体' AS member_type,
        NULL AS member_newold_type,
        NULL AS member_level_type,
        CAST(SUM(t1.sales_income) AS DECIMAL(18, 3)),
        CAST(SUM(t1.sales_item_quantity) AS INTEGER),
        CAST(SUM(t1.lyst_sales_income) AS DECIMAL(18, 3)),
        ARRAY_DISTINCT(FLATTEN(ARRAY_AGG(t1.customer_array))),
        CAST(SUM(t1.order_amount) AS INTEGER),
        t1.date,
        concat(t1.year, '-', t1.month) AS year_month,
        DATE_FORMAT(t1.date, '%Y-%m-%d') AS vchr_date
    FROM ads_crm.member_analyse_daily_income_detail t1
    WHERE t1.date > (SELECT max_date FROM ads_crm.member_analyse_max_date)
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
        t1.trade_source,
        t1.date,
        t1.year,
        t1.month

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
        t2.trade_source,
        NULL AS member_type,
        '会员' AS member_newold_type,
        NULL AS member_level_type,
        CAST(SUM(t2.sales_income) AS DECIMAL(18, 3)),
        CAST(SUM(t2.sales_item_quantity) AS INTEGER),
        CAST(SUM(t2.lyst_sales_income) AS DECIMAL(18, 3)),
        ARRAY_DISTINCT(FLATTEN(ARRAY_AGG(t2.customer_array))),
        CAST(SUM(t2.order_amount) AS INTEGER),
        t2.date,
        concat(t2.year, '-', t2.month) AS year_month,
        DATE_FORMAT(t2.date, '%Y-%m-%d') AS vchr_date
    FROM ads_crm.member_analyse_daily_income_detail t2
    WHERE t2.member_type = '会员'
    AND t2.date > (SELECT max_date FROM ads_crm.member_analyse_max_date)
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
        t2.trade_source,
        t2.date,
        t2.year,
        t2.month

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
        t3.trade_source,
        NULL AS member_type,
        NULL AS member_newold_type,
        '会员' AS member_level_type,
        CAST(SUM(t3.sales_income) AS DECIMAL(18, 3)),
        CAST(SUM(t3.sales_item_quantity) AS INTEGER),
        CAST(SUM(t3.lyst_sales_income) AS DECIMAL(18, 3)),
        ARRAY_DISTINCT(FLATTEN(ARRAY_AGG(t3.customer_array))),
        CAST(SUM(t3.order_amount) AS INTEGER),
        t3.date,
        concat(t3.year, '-', t3.month) AS year_month,
        DATE_FORMAT(t3.date, '%Y-%m-%d') AS vchr_date
    FROM ads_crm.member_analyse_daily_income_detail t3
    WHERE t3.member_type = '会员'
    AND t3.date > (SELECT max_date FROM ads_crm.member_analyse_max_date)
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
        t3.trade_source,
        t3.date,
        t3.year,
        t3.month;