INSERT INTO ads_crm.member_analyse_income_total_detail
    WITH l AS (
        SELECT DISTINCT a.brand_name AS brand, a.order_channel, a.{zone} AS zone, a.member_type, b.date
        FROM (
            SELECT DISTINCT brand_name, member_type, {zone}, 'key' AS key
            FROM ads_crm.member_analyse_fold_index_label
            WHERE member_type IS NOT NULL
        ) a FULL JOIN (
            SELECT DISTINCT date(order_deal_time) date, 'key' AS key
            FROM cdm_crm.order_info_detail
            WHERE date(order_deal_time) <= date(localtimestamp)
            AND date(order_deal_time) >= date(date_format(localtimestamp, '%Y-01-01'))
        ) b ON a.key = b.key
    ), tt AS (
        SELECT brand_name, order_channel, {zone}, cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income, date
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type = '整体' AND member_newold_type IS NULL AND member_level_type IS NULL
        AND date <= DATE(localtimestamp)
        AND date >= DATE(date_format(localtimestamp, '%Y-01-01'))
        GROUP BY brand_name, order_channel, {zone}, date
    ), lyst AS (
        SELECT brand_name, order_channel, {zone}, member_type,
        cast(sum(sales_income) AS DECIMAL(18, 3)) AS sales_income,
        array_distinct(array_agg(store_code)) AS store_array,
        date
        FROM ads_crm.member_analyse_fold_daily_income_detail
        WHERE member_type IS NOT NULL AND member_newold_type IS NULL AND member_level_type IS NULL
        AND date <= DATE(DATE(localtimestamp) - INTERVAL '1' YEAR)
        AND date >= DATE(DATE(date_format(localtimestamp, '%Y-01-01')) - INTERVAL '1' YEAR)
        GROUP BY brand_name, order_channel, {zone}, member_type, date
    ), ss AS (
        SELECT ss.brand_name, ss.order_channel, ss.{zone}, ss.member_type, ss.date,
        array_intersect(array_distinct(array_agg(ss.store_code)), lyst.store_array) AS store_array
        FROM ads_crm.member_analyse_fold_daily_income_detail ss
        LEFT JOIN lyst ON ss.brand_name = lyst.brand_name
        AND ss.order_channel = lyst.order_channel
        AND ss.{zone} = lyst.{zone}
        AND ss.member_type = lyst.member_type
        AND ss.date - interval '1' year = lyst.date
        WHERE ss.member_type IS NOT NULL AND ss.member_newold_type IS NULL AND ss.member_level_type IS NULL
        AND ss.date <= date(localtimestamp)
        AND ss.date >= date(date_format(localtimestamp, '%Y-01-01'))
        GROUP BY ss.brand_name, ss.order_channel, ss.{zone}, ss.member_type, lyst.store_array, ss.date
    ), ss_lyst AS (
        SELECT ss_l.brand_name, ss_l.order_channel, ss_l.{zone}, ss_l.member_type, ss_l.date,
        cast(sum(ss_l.sales_income) AS DECIMAL(18, 3)) AS sales_income
        FROM ads_crm.member_analyse_fold_daily_income_detail ss_l
        LEFT JOIN ss ON ss_l.brand_name = ss.brand_name
        AND ss_l.order_channel = ss.order_channel
        AND ss_l.{zone} = ss.{zone}
        AND ss_l.member_type = ss.member_type
        AND ss.date - interval '1' year = ss_l.date
        WHERE ss_l.member_type IS NOT NULL AND ss_l.member_newold_type IS NULL AND ss_l.member_level_type IS NULL
        AND contains(ss.store_array, ss_l.store_code)
        AND ss_l.date <= date(date(localtimestamp) - interval '1' year)
        AND ss_l.date >= date(date(date_format(localtimestamp, '%Y-01-01')) - interval '1' year)
        GROUP BY ss_l.brand_name, ss_l.order_channel, ss_l.{zone}, ss_l.member_type, ss_l.date
    ), ss_now AS (
        SELECT DISTINCT
            f.brand_name,
            f.order_channel,
            f.{zone},
            f.member_type,
            cast(COALESCE(TRY(sum(f.sales_income) * 1.0 / ss_lyst.sales_income), 0) AS DECIMAL(18, 4)) AS compared_with_ss_lyst,
            f.date
        FROM ads_crm.member_analyse_fold_daily_income_detail f
        LEFT JOIN ss_lyst ON f.brand_name = ss_lyst.brand_name
        AND f.order_channel = ss_lyst.order_channel
        AND f.{zone} = ss_lyst.{zone}
        AND f.member_type = ss_lyst.member_type
        AND f.date - interval '1' year = ss_lyst.date
        LEFT JOIN ss ON f.brand_name = ss.brand_name
        AND f.order_channel = ss.order_channel
        AND f.{zone} = ss.{zone}
        AND f.member_type = ss.member_type
        AND f.date = ss.date
        WHERE f.member_type IS NOT NULL AND f.member_newold_type IS NULL AND f.member_level_type IS NULL
        AND contains(ss.store_array, f.store_code)
        AND f.date <= date(localtimestamp)
        AND f.date >= date(date_format(localtimestamp, '%Y-01-01'))
        GROUP BY f.brand_name, f.order_channel, f.{zone}, f.member_type, ss_lyst.sales_income, f.date
    ), d AS (
        SELECT DISTINCT
            f.brand_name    AS brand,
            f.order_channel AS order_channel,
            f.{zone}        AS zone,
            '{zone}'        AS zone_type,
            f.member_type   AS member_type,
            cast(sum(f.sales_income) AS DECIMAL(18, 3)) AS sales_income,
            cast(COALESCE(TRY(sum(f.sales_income) * 1.0 / tt.sales_income), 0) AS DECIMAL(18, 4)) AS sales_income_proportion,
            cast(COALESCE(TRY(sum(f.sales_income) * 1.0 / lyst.sales_income), 0) AS DECIMAL(18, 4)) AS compared_with_lyst,
            cast(COALESCE(ss_now.compared_with_ss_lyst, 0) AS DECIMAL(18, 4)) AS compared_with_ss_lyst,
            f.date
        FROM ads_crm.member_analyse_fold_daily_income_detail f
        LEFT JOIN tt ON f.brand_name = tt.brand_name
        AND f.order_channel = tt.order_channel
        AND f.{zone} = tt.{zone}
        AND f.date = tt.date
        LEFT JOIN lyst ON f.brand_name = lyst.brand_name
        AND f.order_channel = lyst.order_channel
        AND f.{zone} = lyst.{zone}
        AND f.member_type = lyst.member_type
        AND f.date - INTERVAL '1' YEAR = lyst.date
        LEFT JOIN ss_now ON f.brand_name = ss_now.brand_name
        AND f.order_channel = ss_now.order_channel
        AND f.{zone} = ss_now.{zone}
        AND f.member_type = ss_now.member_type
        AND f.date = ss_now.date
        WHERE f.member_type IS NOT NULL AND f.member_newold_type IS NULL AND f.member_level_type IS NULL
        AND f.date <= DATE('{end_date}')
        AND f.date >= DATE('{start_date}')
        GROUP BY f.brand_name, f.{zone}, f.member_type, tt.sales_income, lyst.sales_income, ss_now.compared_with_ss_lyst, f.date
    )
    SELECT DISTINCT l.brand, l.order_channel, l.zone, l.member_type,
    COALESCE(d.sales_income, 0) AS sales_income,
    COALESCE(d.sales_income_proportion, 0) AS sales_income_proportion,
    COALESCE(d.compared_with_lyst, 0) AS compared_with_lyst,
    COALESCE(d.compared_with_ss_lyst, 0) AS compared_with_ss_lyst,
    l.date,
    'yearly' AS duration_type,
    localtimestamp AS create_time
    FROM l LEFT JOIN d ON l.brand = d.brand
    AND l.order_channel = d.order_channel
    AND l.zone = d.zone
    AND l.member_type = d.member_type
    AND l.date = d.date;
