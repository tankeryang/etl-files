INSERT INTO ads_crm.member_analyse_income_member_new_old_daily
    WITH tt AS (
        SELECT
            brand_name AS brand,
            IF ({zone} IS NULL, '', {zone}) AS zone,
            IF (order_channel IS NULL, '全部', order_channel) AS order_channel,
            sales_mode,
            store_type,
            store_level,
            channel_type,
            cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income,
            date
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type IS NULL AND member_newold_type = '会员' AND member_level_type IS NULL
            AND vchr_date < date_format(localtimestamp, '%Y-%m-%d')
            AND vchr_date > (SELECT vchr_max_date FROM ads_crm.member_analyse_max_date)
        GROUP BY DISTINCT
            brand_name, {zone}, sales_mode, store_type, store_level, channel_type, date,
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
            cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income,
            date
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type IS NULL AND member_newold_type IS NOT NULL AND member_level_type IS NULL
            AND vchr_date < date(localtimestamp) - interval '1' year
            AND vchr_date > (SELECT date_format(max_date - interval '1' year, '%Y-%m-%d') FROM ads_crm.member_analyse_max_date)
        GROUP BY DISTINCT
            brand_name, {zone}, member_type, sales_mode, store_type, store_level, channel_type, date,
            CUBE (order_channel)
    ), tmp AS (
        SELECT DISTINCT
            f.brand_name    AS brand,
            IF (f.{zone} IS NULL, '', f.{zone}) AS zone,
            f.member_newold_type   AS member_type,
            IF (f.order_channel IS NULL, '全部', f.order_channel) AS order_channel,
            sales_mode,
            store_type,
            store_level,
            channel_type,
            cast(sum(f.sales_income) AS DECIMAL(18, 3)) AS sales_income,
            cast(sum(f.lyst_sales_income) AS DECIMAL(18, 3)) AS lyst_sales_income,
            f.date,
            localtimestamp AS create_time
        FROM ads_crm.member_analyse_fold_daily_income_detail f
        WHERE f.member_type IS NULL AND f.member_newold_type IS NOT NULL AND f.member_level_type IS NULL
            AND f.vchr_date < date(localtimestamp, '%Y-%m-%d')
            AND f.vchr_date > (SELECT vchr_max_date FROM ads_crm.member_analyse_max_date)
        GROUP BY DISTINCT
            f.brand_name, f.{zone}, f.member_type, f.sales_mode, f.store_type, f.store_level, f.channel_type, f.date,
            CUBE (f.order_channel)
    )
    SELECT DISTINCT
        tmp.brand,
        IF (tmp.zone = '', NULL, tmp.zone) AS zone,
        tmp.member_type,
        tmp.order_channel,
        tmp.sales_mode,
        tmp.store_type,
        tmp.store_level,
        tmp.channel_type,
        cast(sum(tmp.sales_income) AS DECIMAL(18, 3)) AS sales_income,
        cast(COALESCE(TRY(sum(tmp.sales_income) / sum(tt.sales_income) * 1.0), 0) AS DECIMAL(18, 4)) AS sales_income_proportion,
        cast(COALESCE(TRY(sum(tmp.sales_income) / sum(lyst.sales_income) * 1.0), 0) AS DECIMAL(18, 4)) AS compared_with_lyst,
        cast(COALESCE(TRY(sum(tmp.sales_income) / sum(tmp.lyst_sales_income) * 1.0), 0) AS DECIMAL(18, 4)) AS compared_with_ss_lyst,
        tmp.date,
        tmp.create_time,
        date_format(tmp.date, '%Y-%m-%d') AS vchr_date
    FROM tmp
    LEFT JOIN tt ON tmp.brand = tt.brand
        AND tmp.zone = tt.zone
        AND tmp.order_channel = tt.order_channel
        AND tmp.sales_mode = tt.sales_mode
        AND tmp.store_type = tt.store_type
        AND tmp.store_level = tt.store_level
        AND tmp.channel_type = tt.channel_type
        AND tmp.date = tt.date
    LEFT JOIN lyst ON tmp.brand = lyst.brand
        AND tmp.zone = lyst.zone
        AND tmp.member_type = lyst.member_type
        AND tmp.order_channel = lyst.order_channel
        AND tmp.sales_mode = lyst.sales_mode
        AND tmp.store_type = lyst.store_type
        AND tmp.store_level = lyst.store_level
        AND tmp.channel_type = lyst.channel_type
        AND tmp.date - interval '1' year = lyst.date
    GROUP BY
        tmp.brand,
        tmp.zone,
        tmp.member_type,
        tmp.order_channel,
        tmp.sales_mode,
        tmp.store_type,
        tmp.store_level,
        tmp.channel_type,
        tmp.date,
        tmp.create_time;
