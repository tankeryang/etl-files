INSERT INTO ads_crm.member_analyse_income_total_all
    WITH tt AS (
        SELECT
            brand_name,
            {zone},
            order_channel,
            sales_mode,
            store_type,
            store_level,
            channel_type,
            cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type = '整体' AND member_newold_type IS NULL AND member_level_type IS NULL
            AND date <= date(localtimestamp)
            AND date >= date(date_format(localtimestamp, '%Y-%m-01'))
        GROUP BY DISTINCT
            brand_name, {zone},
            order_channel, sales_mode, store_type, store_level, channel_type
    ), lyst AS (
        SELECT
            brand_name,
            {zone},
            member_type,
            order_channel,
            sales_mode,
            store_type,
            store_level,
            channel_type,
            cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income,
            array_distinct(array_agg(store_code)) AS store_array
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type IS NOT NULL AND member_newold_type IS NULL AND member_level_type IS NULL
            AND date <= date(localtimestamp)
            AND date >= date(date_format(localtimestamp, '%Y-%m-01'))
        GROUP BY DISTINCT
            brand_name, {zone}, member_type,
            order_channel, sales_mode, store_type, store_level, channel_type
    ), ss AS (
        SELECT
            ss.brand_name,
            ss.{zone},
            ss.member_type,
            ss.order_channel,
            ss.sales_mode,
            ss.store_type,
            ss.store_level,
            ss.channel_type,
            array_intersect(array_distinct(array_agg(ss.store_code)), lyst.store_array) AS store_array
        FROM ads_crm.member_analyse_fold_daily_income_detail ss
        LEFT JOIN lyst ON ss.brand_name = lyst.brand_name
            AND ss.{zone} = lyst.{zone}
            AND ss.member_type = lyst.member_type
            AND ss.order_channel = lyst.order_channel
            AND ss.sales_mode = lyst.sales_mode
            AND ss.store_type = lyst.store_type
            AND ss.store_level = lyst.store_level
            AND ss.channel_type = lyst.channel_type
        WHERE ss.member_type IS NOT NULL AND ss.member_newold_type IS NULL AND ss.member_level_type IS NULL
            AND date <= date(localtimestamp)
            AND date >= date(date_format(localtimestamp, '%Y-%m-01'))
        GROUP BY DISTINCT
            ss.brand_name, ss.{zone}, ss.member_type, lyst.store_array,
            ss.order_channel, ss.sales_mode, ss.store_type, ss.store_level, ss.channel_type
    ), ss_lyst AS (
        SELECT
            ss_l.brand_name,
            ss_l.{zone},
            ss_l.member_type,
            ss_l.order_channel,
            ss_l.sales_mode,
            ss_l.store_type,
            ss_l.store_level,
            ss_l.channel_type,
            cast(sum(ss_l.sales_income) AS DECIMAL(18, 3)) AS sales_income
        FROM ads_crm.member_analyse_fold_daily_income_detail ss_l
        LEFT JOIN ss ON ss_l.brand_name = ss.brand_name
            AND ss_l.{zone} = ss.{zone}
            AND ss_l.member_type = ss.member_type
            AND ss_l.order_channel = ss.order_channel
            AND ss_l.sales_mode = ss.sales_mode
            AND ss_l.store_type = ss.store_type
            AND ss_l.store_level = ss.store_level
            AND ss_l.channel_type = ss.channel_type
        WHERE ss_l.member_type IS NOT NULL AND ss_l.member_newold_type IS NULL AND ss_l.member_level_type IS NULL
            AND contains(ss.store_array, ss_l.store_code)
            AND date <= date(localtimestamp)
            AND date >= date(date_format(localtimestamp, '%Y-%m-01'))
        GROUP BY DISTINCT
            ss_l.brand_name, ss_l.{zone}, ss_l.member_type,
            ss_l.order_channel, ss_l.sales_mode, ss_l.store_type, ss_l.store_level, ss_l.channel_type
    ), ss_now AS (
        SELECT DISTINCT
            f.brand_name,
            f.{zone},
            f.member_type,
            f.order_channel,
            f.sales_mode,
            f.store_type,
            f.store_level,
            f.channel_type,
            cast(COALESCE(TRY(sum(f.sales_income) * 1.0 / ss_lyst.sales_income), 0) AS DECIMAL(18, 4)) AS compared_with_ss_lyst
        FROM ads_crm.member_analyse_fold_daily_income_detail f
        LEFT JOIN ss_lyst ON f.brand_name = ss_lyst.brand_name
            AND f.{zone} = ss_lyst.{zone}
            AND f.member_type = ss_lyst.member_type
            AND f.order_channel = ss_lyst.order_channel
            AND f.sales_mode = ss_lyst.sales_mode
            AND f.store_type = ss_lyst.store_type
            AND f.store_level = ss_lyst.store_level
            AND f.channel_type = ss_lyst.channel_type
        LEFT JOIN ss ON f.brand_name = ss.brand_name
            AND f.{zone} = ss.{zone}
            AND f.member_type = ss.member_type
            AND f.order_channel = ss.order_channel
            AND f.sales_mode = ss.sales_mode
            AND f.store_type = ss.store_type
            AND f.store_level = ss.store_level
            AND f.channel_type = ss.channel_type
        WHERE f.member_type IS NOT NULL AND f.member_newold_type IS NULL AND f.member_level_type IS NULL
            AND contains(ss.store_array, f.store_code)
            AND date <= date(localtimestamp)
            AND date >= date(date_format(localtimestamp, '%Y-%m-01'))
        GROUP BY DISTINCT
            f.brand_name, f.{zone}, f.member_type, ss_lyst.sales_income,
            f.order_channel, f.sales_mode, f.store_type, f.store_level, f.channel_type
    )
    SELECT DISTINCT
        f.brand_name    AS brand,
        f.{zone}        AS zone,
        '{zone}'        AS zone_type,
        f.member_type   AS member_type,
        IF (f.order_channel IS NULL, '全部', f.order_channel) AS order_channel,
        IF (f.sales_mode IS NULL, '全部', f.sales_mode) AS sales_mode,
        IF (f.store_type IS NULL, '全部', f.store_type) AS store_type,
        IF (f.store_level IS NULL, '全部', f.store_level) AS store_level,
        IF (f.channel_type IS NULL, '全部', f.channel_type) AS channel_type,
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
        'monthly' AS duration_type,
        localtimestamp AS create_time
    FROM ads_crm.member_analyse_fold_daily_income_detail f
    LEFT JOIN tt ON f.brand_name = tt.brand_name
        AND f.{zone} = tt.{zone}
        AND f.order_channel = tt.order_channel
        AND f.sales_mode = tt.sales_mode
        AND f.store_type = tt.store_type
        AND f.store_level = tt.store_level
        AND f.channel_type = tt.channel_type
    LEFT JOIN lyst ON f.brand_name = lyst.brand_name
        AND f.{zone} = lyst.{zone}
        AND f.member_type = lyst.member_type
        AND f.order_channel = lyst.order_channel
        AND f.sales_mode = lyst.sales_mode
        AND f.store_type = lyst.store_type
        AND f.store_level = lyst.store_level
        AND f.channel_type = lyst.channel_type
    LEFT JOIN ss_now ON f.brand_name = ss_now.brand_name
        AND f.{zone} = ss_now.{zone}
        AND f.member_type = ss_now.member_type
        AND f.order_channel = ss_now.order_channel
        AND f.sales_mode = ss_now.sales_mode
        AND f.store_type = ss_now.store_type
        AND f.store_level = ss_now.store_level
        AND f.channel_type = ss_now.channel_type
    WHERE f.member_type IS NOT NULL AND f.member_newold_type IS NULL AND f.member_level_type IS NULL
        AND date <= date(localtimestamp)
        AND date >= date(date_format(localtimestamp, '%Y-%m-01'))
    GROUP BY DISTINCT
        f.brand_name, f.{zone}, f.member_type, tt.sales_income, lyst.sales_income, ss_now.compared_with_ss_lyst,
        CUBE (f.order_channel, f.sales_mode, f.store_type, f.store_level, f.channel_type);