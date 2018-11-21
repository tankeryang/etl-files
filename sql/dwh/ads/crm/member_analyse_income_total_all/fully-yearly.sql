INSERT INTO ads_crm.member_analyse_income_total_all
    WITH tt AS (
        SELECT brand_name, order_channel, {zone}, cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type = '整体' AND member_newold_type IS NULL AND member_level_type IS NULL
        AND date <= date(localtimestamp)
        AND date >= date(date_format(localtimestamp, '%Y-01-01'))
        GROUP BY brand_name, order_channel, {zone}
    ), lyst AS (
        SELECT brand_name, order_channel, {zone}, member_type,
            cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income,
            array_distinct(array_agg(store_code)) AS store_array
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type IS NOT NULL AND member_newold_type IS NULL AND member_level_type IS NULL
        AND date <= date(date(localtimestamp) - interval '1' year)
        AND date >= date(date(date_format(localtimestamp, '%Y-01-01')) - interval '1' year)
        GROUP BY brand_name, order_channel, {zone}, member_type
    ), ss AS (
        SELECT ss.brand_name, ss.order_channel, ss.{zone}, ss.member_type,
            array_intersect(array_distinct(array_agg(ss.store_code)), lyst.store_array) AS store_array
        FROM ads_crm.member_analyse_fold_daily_income_detail ss
        LEFT JOIN lyst ON ss.brand_name = lyst.brand_name AND ss.order_channel = lyst.order_channel
        AND ss.{zone} = lyst.{zone} AND ss.member_type = lyst.member_type
        WHERE ss.member_type IS NOT NULL AND ss.member_newold_type IS NULL AND ss.member_level_type IS NULL
        AND ss.date <= date(localtimestamp)
        AND ss.date >= date(date_format(localtimestamp, '%Y-01-01'))
        GROUP BY ss.brand_name, ss.order_channel, ss.{zone}, ss.member_type, lyst.store_array
    ), ss_lyst AS (
        SELECT ss_l.brand_name, ss_l.order_channel, ss_l.{zone}, ss_l.member_type,
            cast(sum(ss_l.sales_income) AS DECIMAL(18, 3)) AS sales_income
        FROM ads_crm.member_analyse_fold_daily_income_detail ss_l
        LEFT JOIN ss ON ss_l.brand_name = ss.brand_name AND ss.order_channel = ss_l.order_channel
        AND ss_l.{zone} = ss.{zone} AND ss_l.member_type = ss.member_type
        WHERE ss_l.member_type IS NOT NULL AND ss_l.member_newold_type IS NULL AND ss_l.member_level_type IS NULL
        AND contains(ss.store_array, ss_l.store_code)
        AND ss_l.date <= date(date(localtimestamp) - interval '1' year)
        AND ss_l.date >= date(date(date_format(localtimestamp, '%Y-01-01')) - interval '1' year)
        GROUP BY ss_l.brand_name, ss_l.order_channel, ss_l.{zone}, ss_l.member_type
    ), ss_now AS (
        SELECT DISTINCT f.brand_name, f.order_channel, f.{zone}, f.member_type,
            cast(COALESCE(TRY(sum(f.sales_income) * 1.0 / ss_lyst.sales_income), 0) AS DECIMAL(18, 4)) AS compared_with_ss_lyst
        FROM ads_crm.member_analyse_fold_daily_income_detail f
        LEFT JOIN ss_lyst ON f.brand_name = ss_lyst.brand_name AND f.order_channel = ss_lyst.order_channel
        AND f.{zone} = ss_lyst.{zone} AND f.member_type = ss_lyst.member_type
        LEFT JOIN ss ON f.brand_name = ss.brand_name AND f.order_channel = ss.order_channel
        AND f.{zone} = ss.{zone} AND f.member_type = ss.member_type
        WHERE f.member_type IS NOT NULL AND f.member_newold_type IS NULL AND f.member_level_type IS NULL
        AND contains(ss.store_array, f.store_code)
        AND f.date <= date(localtimestamp)
        AND f.date >= date(date_format(localtimestamp, '%Y-01-01'))
        GROUP BY f.brand_name, f.order_channel, f.{zone}, f.member_type, ss_lyst.sales_income
    )
    SELECT DISTINCT
        f.brand_name    AS brand,
        f.order_channel AS order_channel,
        f.{zone}        AS zone,
        '{zone}'        AS zone_type,
        f.member_type   AS member_type,
        cast(sum(f.sales_income) AS DECIMAL(18, 3)) AS sales_income,
        cast(COALESCE(TRY(sum(f.sales_income) * 1.0 / tt.sales_income), 0) AS DECIMAL(18, 4)) AS sales_income_proportion,
        cast(cardinality(array_distinct(flatten(array_agg(f.customer_array)))) AS INTEGER) AS customer_amount,
        cast(sum(f.order_amount) AS INTEGER) AS order_amount,
        cast(COALESCE(TRY(sum(f.order_amount) / cardinality(array_distinct(flatten(array_agg(f.customer_array))))), 0) AS INTEGER) AS consumption_frequency,
        cast(COALESCE(TRY(sum(f.sales_income) * 1.0 / sum(f.order_amount)), 0) AS DECIMAL(18, 2)) AS sales_income_per_order,
        cast(COALESCE(TRY(sum(f.sales_income) * 1.0 / sum(f.sales_item_quantity)), 0) AS DECIMAL(18, 2)) AS sales_income_per_item,
        cast(COALESCE(TRY(sum(f.sales_item_quantity) * 1.0 / sum(f.order_amount)), 0) AS DECIMAL(18, 2)) AS sales_item_per_order,
        cast(COALESCE(TRY(sum(f.sales_income) * 1.0 / lyst.sales_income), 0) AS DECIMAL(18, 4)) AS compared_with_lyst,
        cast(COALESCE(ss_now.compared_with_ss_lyst, 0) AS DECIMAL(18, 4)) AS compared_with_ss_lyst,
        'yearly' AS duration_type,
        localtimestamp AS create_time
    FROM ads_crm.member_analyse_fold_daily_income_detail f
    LEFT JOIN tt ON f.brand_name = tt.brand_name AND f.order_channel = tt.order_channel AND f.{zone} = tt.{zone}
    LEFT JOIN lyst ON f.brand_name = lyst.brand_name AND f.order_channel = lyst.order_channel
    AND f.{zone} = lyst.{zone} AND f.member_type = lyst.member_type
    LEFT JOIN ss_now ON f.brand_name = ss_now.brand_name AND f.order_channel = ss_now.order_channel
    AND f.{zone} = ss_now.{zone} AND f.member_type = ss_now.member_type
    WHERE f.member_type IS NOT NULL AND f.member_newold_type IS NULL AND f.member_level_type IS NULL
    AND f.date <= date(localtimestamp) AND f.date >= date(date_format(localtimestamp, '%Y-01-01'))
    GROUP BY f.brand_name, f.order_channel, f.{zone}, f.member_type, tt.sales_income, lyst.sales_income, ss_now.compared_with_ss_lyst
