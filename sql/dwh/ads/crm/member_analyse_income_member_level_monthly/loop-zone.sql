INSERT INTO ads_crm.member_analyse_income_member_level_monthly
    WITH tt AS (
        SELECT
            brand_name AS brand,
            IF ({zone} IS NULL, '', {zone}) AS zone,
            IF (order_channel IS NULL, '全部', order_channel) AS order_channel,
            IF (sales_mode IS NULL, '全部', sales_mode) AS sales_mode,
            IF (store_type IS NULL, '全部', store_type) AS store_type,
            IF (store_level IS NULL, '全部', store_level) AS store_level,
            IF (channel_type IS NULL, '全部', channel_type) AS channel_type,
            cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income,
            year,
            month
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type IS NULL AND member_newold_type IS NULL AND member_level_type = '会员'
            AND vchr_date <= '{last_date_of_last_month}'
            AND month > (SELECT last_month FROM ads_crm.member_analyse_max_date)
        GROUP BY DISTINCT
            brand_name, {zone}, year, month,
            CUBE (order_channel, sales_mode, store_type, store_level, channel_type)
    ), lyst AS (
        SELECT
            brand_name AS brand,
            IF ({zone} IS NULL, '', {zone}) AS zone,
            member_level_type AS member_type,
            IF (order_channel IS NULL, '全部', order_channel) AS order_channel,
            IF (sales_mode IS NULL, '全部', sales_mode) AS sales_mode,
            IF (store_type IS NULL, '全部', store_type) AS store_type,
            IF (store_level IS NULL, '全部', store_level) AS store_level,
            IF (channel_type IS NULL, '全部', channel_type) AS channel_type,
            cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income,
            year,
            month
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type IS NULL AND member_newold_type IS NULL AND member_level_type IS NOT NULL
            AND year < cast(year(localtimestamp) AS VARCHAR)
            AND month > (SELECT last_month FROM ads_crm.member_analyse_max_date)
        GROUP BY DISTINCT
            brand_name, {zone}, member_type, year, month,
            CUBE (order_channel, sales_mode, store_type, store_level, channel_type)
    ), tmp AS (
        SELECT
            f.brand_name    AS brand,
            IF (f.{zone} IS NULL, '', f.{zone}) AS zone,
            f.member_level_type   AS member_type,
            IF (f.order_channel IS NULL, '全部', f.order_channel) AS order_channel,
            IF (f.sales_mode IS NULL, '全部', f.sales_mode) AS sales_mode,
            IF (f.store_type IS NULL, '全部', f.store_type) AS store_type,
            IF (f.store_level IS NULL, '全部', f.store_level) AS store_level,
            IF (f.channel_type IS NULL, '全部', f.channel_type) AS channel_type,
            cast(sum(f.sales_income) AS DECIMAL(18, 3)) AS sales_income,
            cast(sum(f.lyst_sales_income) AS DECIMAL(18, 3)) AS lyst_sales_income,
            f.year,
            f.month,
            localtimestamp AS create_time
        FROM ads_crm.member_analyse_fold_daily_income_detail f
        WHERE f.member_type IS NULL AND f.member_newold_type IS NULL AND f.member_level_type IS NOT NULL
            AND f.vchr_date < '{last_date_of_last_month}'
            AND month > (SELECT last_month FROM ads_crm.member_analyse_max_date)
        GROUP BY DISTINCT
            f.brand_name, f.{zone}, f.member_type, f.year, f.month,
            CUBE (f.order_channel, f.sales_mode, f.store_type, f.store_level, f.channel_type)
    )
    SELECT
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
        tmp.create_time,
        tmp.year,
        tmp.month
    FROM tmp
    LEFT JOIN tt ON tmp.brand = tt.brand
        AND tmp.zone = tt.zone
        AND tmp.order_channel = tt.order_channel
        AND tmp.sales_mode = tt.sales_mode
        AND tmp.store_type = tt.store_type
        AND tmp.store_level = tt.store_level
        AND tmp.channel_type = tt.channel_type
        AND tmp.year = tt.year
        AND tmp.month = tt.month
    LEFT JOIN lyst ON tmp.brand = lyst.brand
        AND tmp.zone = lyst.zone
        AND tmp.member_type = lyst.member_type
        AND tmp.order_channel = lyst.order_channel
        AND tmp.sales_mode = lyst.sales_mode
        AND tmp.store_type = lyst.store_type
        AND tmp.store_level = lyst.store_level
        AND tmp.channel_type = lyst.channel_type
        AND tmp.year - 1 = lyst.year
        AND tmp.month = lyst.month
    GROUP BY
        tmp.brand,
        tmp.zone,
        tmp.member_type,
        tmp.order_channel,
        tmp.sales_mode,
        tmp.store_type,
        tmp.store_level,
        tmp.channel_type,
        tmp.year,
        tmp.month,
        tmp.create_time;
