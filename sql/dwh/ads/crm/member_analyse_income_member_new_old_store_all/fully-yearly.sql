INSERT INTO ads_crm.member_analyse_income_member_new_old_store_all
    WITH tt AS (
        SELECT
            brand_name AS brand,
            IF ({zone} IS NULL, '', {zone}) AS zone,
            IF (order_channel IS NULL, '全部', order_channel) AS order_channel,
            sales_mode,
            store_type,
            store_level,
            channel_type,
            cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type IS NULL AND member_newold_type = '会员' AND member_level_type IS NULL
            AND date <= date(localtimestamp)
            AND date >= date(date_format(localtimestamp, '%Y-01-01'))
        GROUP BY DISTINCT
            brand_name, {zone}, sales_mode, store_type, store_level, channel_type,
            CUBE (order_channel)
    ), lyst AS (
        SELECT
            brand_name AS brand,
            IF ({zone} IS NULL, '', {zone}) AS zone,
            member_newold_type AS member_type,
            IF (order_channel IS NULL, '全部', order_channel) AS order_channel,
            sales_mode,
            store_type,
            store_level,
            channel_type,
            cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type IS NULL AND member_newold_type IS NOT NULL AND member_level_type IS NULL
            AND date <= date(localtimestamp) - interval '1' year
            AND date >= date(date_format(localtimestamp, '%Y-01-01')) - interval '1' year
        GROUP BY DISTINCT
            brand_name, {zone}, member_newold_type, sales_mode, store_type, store_level, channel_type,
            CUBE (order_channel)
    ), tmp AS (
        SELECT DISTINCT
            f.brand_name    AS brand,
            IF (f.{zone} IS NULL, '', f.{zone}) AS zone,
            '{zone}'        AS zone_type,
            f.member_newold_type AS member_type,
            IF (f.order_channel IS NULL, '全部', f.order_channel) AS order_channel,
            sales_mode,
            store_type,
            store_level,
            channel_type,
            cast(sum(f.sales_income) AS DECIMAL(18, 3)) AS sales_income,
            cast(sum(f.lyst_sales_income) AS DECIMAL(18, 3)) AS lyst_sales_income,
            cast(cardinality(array_distinct(flatten(array_agg(f.customer_array)))) AS INTEGER) AS customer_amount,
            cast(sum(f.order_amount) AS INTEGER) AS order_amount,
            cast(COALESCE(TRY(sum(f.order_amount) / cardinality(array_distinct(flatten(array_agg(f.customer_array))))), 0) AS INTEGER) AS consumption_frequency,
            cast(COALESCE(TRY(sum(f.sales_income) * 1.0 / sum(f.order_amount)), 0) AS DECIMAL(18, 2)) AS sales_income_per_order,
            cast(COALESCE(TRY(sum(f.sales_income) * 1.0 / sum(f.sales_item_quantity)), 0) AS DECIMAL(18, 2)) AS sales_income_per_item,
            cast(COALESCE(TRY(sum(f.sales_item_quantity) * 1.0 / sum(f.order_amount)), 0) AS DECIMAL(18, 2)) AS sales_item_per_order,
            'yearly' AS duration_type,
            localtimestamp AS create_time
        FROM ads_crm.member_analyse_fold_daily_income_detail f
        WHERE f.member_type IS NOT NULL AND f.member_newold_type IS NULL AND f.member_level_type IS NULL
            AND date <= date(localtimestamp)
            AND date >= date(date_format(localtimestamp, '%Y-01-01'))
        GROUP BY DISTINCT
            f.brand_name, f.{zone}, f.member_newold_type, f.sales_mode, f.store_type, f.store_level, f.channel_type,
            CUBE (f.order_channel)
    )
    SELECT DISTINCT
        tmp.brand,
        IF (tmp.zone = '', NULL, tmp.zone) AS zone,
        tmp.zone_type,
        tmp.member_type,
        tmp.order_channel,
        tmp.sales_mode,
        tmp.store_type,
        tmp.store_level,
        tmp.channel_type,
        cast(sum(tmp.sales_income) AS DECIMAL(18, 3)) AS sales_income,
        cast(COALESCE(TRY(sum(tmp.sales_income) / sum(tt.sales_income) * 1.0), 0) AS DECIMAL(18, 4)) AS sales_income_proportion,
        cast(sum(tmp.customer_amount) AS INTEGER) AS customer_amount,
        cast(sum(tmp.order_amount) AS INTEGER) AS order_amount,
        cast(sum(tmp.consumption_frequency) AS INTEGER) AS consumption_frequency,
        cast(sum(tmp.sales_income_per_order) AS DECIMAL(18, 2)) AS sales_income_per_order,
        cast(sum(tmp.sales_income_per_item) AS DECIMAL(18, 2)) AS sales_income_per_item,
        cast(sum(tmp.sales_item_per_order) AS DECIMAL(18, 2)) AS sales_item_per_order,
        cast(COALESCE(TRY(sum(tmp.sales_income) / sum(lyst.sales_income) * 1.0), 0) AS DECIMAL(18, 4)) AS compared_with_lyst,
        cast(COALESCE(TRY(sum(tmp.sales_income) / sum(tmp.lyst_sales_income) * 1.0), 0) AS DECIMAL(18, 4)),
        tmp.duration_type,
        tmp.create_time
    FROM tmp
    LEFT JOIN tt ON tmp.brand = tt.brand
        AND tmp.zone = tt.zone
        AND tmp.order_channel = tt.order_channel
        AND tmp.sales_mode = tt.sales_mode
        AND tmp.store_type = tt.store_type
        AND tmp.store_level = tt.store_level
        AND tmp.channel_type = tt.channel_type
    LEFT JOIN lyst ON tmp.brand = lyst.brand
        AND tmp.zone = lyst.zone
        AND tmp.member_type = lyst.member_type
        AND tmp.order_channel = lyst.order_channel
        AND tmp.sales_mode = lyst.sales_mode
        AND tmp.store_type = lyst.store_type
        AND tmp.store_level = lyst.store_level
        AND tmp.channel_type = lyst.channel_type
    GROUP BY
        tmp.brand,
        tmp.zone,
        tmp.zone_type,
        tmp.member_type,
        tmp.order_channel,
        tmp.sales_mode,
        tmp.store_type,
        tmp.store_level,
        tmp.channel_type,
        tmp.duration_type,
        tmp.create_time;
