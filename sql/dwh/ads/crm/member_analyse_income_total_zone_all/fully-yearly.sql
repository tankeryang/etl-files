INSERT INTO ads_crm.member_analyse_income_total_zone_all
    WITH tt AS (
        SELECT
            brand_name AS brand,
            IF ({zone} IS NULL, '', {zone}) AS zone,
            IF (order_channel IS NULL, '全部', order_channel) AS order_channel,
            IF (sales_mode IS NULL, '全部', sales_mode) AS sales_mode,
            IF (store_type IS NULL, '全部', store_type) AS store_type,
            IF (store_level IS NULL, '全部', store_level) AS store_level,
            IF (channel_type IS NULL, '全部', channel_type) AS channel_type,
            cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type = '整体' AND member_newold_type IS NULL AND member_level_type IS NULL
            AND vchr_date < date_format(localtimestamp, '%Y-%m-%d')
            AND vchr_date >= date_format(localtimestamp, '%Y-01-01')
        GROUP BY DISTINCT
            brand_name, {zone},
            CUBE (order_channel, sales_mode, store_type, store_level, channel_type)
    ), lyst AS (
        SELECT
            brand_name AS brand,
            IF ({zone} IS NULL, '', {zone}) AS zone,
            member_type,
            IF (order_channel IS NULL, '全部', order_channel) AS order_channel,
            IF (sales_mode IS NULL, '全部', sales_mode) AS sales_mode,
            IF (store_type IS NULL, '全部', store_type) AS store_type,
            IF (store_level IS NULL, '全部', store_level) AS store_level,
            IF (channel_type IS NULL, '全部', channel_type) AS channel_type,
            cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type IS NOT NULL AND member_newold_type IS NULL AND member_level_type IS NULL
            AND vchr_date < date_format(date(localtimestamp) - interval '1' year, '%Y-%m-%d')
            AND vchr_date >= date_format(date(localtimestamp) - interval '1' year, '%Y-%01-%01')
        GROUP BY DISTINCT
            brand_name, {zone}, member_type,
            CUBE (order_channel, sales_mode, store_type, store_level, channel_type)
    ), tmp AS (
        SELECT DISTINCT
            f.brand_name    AS brand,
            IF (f.{zone} IS NULL, '', f.{zone}) AS zone,
            '{zone}'        AS zone_type,
            f.member_type   AS member_type,
            IF (f.order_channel IS NULL, '全部', f.order_channel) AS order_channel,
            IF (f.sales_mode IS NULL, '全部', f.sales_mode) AS sales_mode,
            IF (f.store_type IS NULL, '全部', f.store_type) AS store_type,
            IF (f.store_level IS NULL, '全部', f.store_level) AS store_level,
            IF (f.channel_type IS NULL, '全部', f.channel_type) AS channel_type,
            cast(sum(f.sales_income) AS DECIMAL(18, 3)) AS sales_income,
            cast(sum(f.lyst_sales_income) AS DECIMAL(18, 3)) AS lyst_sales_income,
            cast(cardinality(array_distinct(flatten(array_agg(f.customer_array)))) AS INTEGER) AS customer_amount,
            cast(sum(f.order_amount) AS INTEGER) AS order_amount,
            cast(sum(f.sales_item_quantity) AS INTEGER) AS sales_item_quantity,
            'yearly' AS duration_type,
            localtimestamp AS create_time
        FROM ads_crm.member_analyse_fold_daily_income_detail f
        WHERE f.member_type IS NOT NULL AND f.member_newold_type IS NULL AND f.member_level_type IS NULL
            AND vchr_date < date_format(localtimestamp, '%Y-%m-%d')
            AND vchr_date >= date_format(localtimestamp, '%Y-01-01')
        GROUP BY DISTINCT
            f.brand_name, f.{zone}, f.member_type,
            CUBE (f.order_channel, f.sales_mode, f.store_type, f.store_level, f.channel_type)
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
        cast(COALESCE(TRY(sum(tmp.order_amount) / sum(tmp.customer_amount) * 1.0), 0) AS INTEGER) AS consumption_frequency,
        cast(COALESCE(TRY(sum(tmp.sales_income) / sum(tmp.order_amount) * 1.0), 0) AS DECIMAL(18, 2)) AS sales_income_per_order,
        cast(COALESCE(TRY(sum(tmp.sales_income) / sum(tmp.sales_item_quantity) * 1.0), 0) AS DECIMAL(18, 2)) AS sales_income_per_item,
        cast(COALESCE(TRY(sum(tmp.sales_item_quantity) / sum(tmp.order_amount) * 1.0), 0) AS DECIMAL(18, 2)) AS sales_item_per_order,
        cast(COALESCE(TRY(sum(tmp.sales_income) / sum(lyst.sales_income) * 1.0), 0) AS DECIMAL(18, 4)) AS compared_with_lyst,
        cast(COALESCE(TRY(sum(tmp.sales_income) / sum(tmp.lyst_sales_income) * 1.0), 0) AS DECIMAL(18, 4)) AS compared_with_ss_lyst,
        tmp.create_time,
        tmp.duration_type
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
