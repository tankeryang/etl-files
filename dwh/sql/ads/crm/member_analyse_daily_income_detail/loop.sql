INSERT INTO ads_crm.member_analyse_daily_income_detail
    WITH i AS (
        SELECT
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
            t2.member_type,
            t2.member_newold_type,
            t2.member_level_type,
            t2.member_upgrade_type,
            t2.member_register_type,
            t1.date
        FROM (
            SELECT DISTINCT
                country,
                sales_area,
                sales_district,
                province,
                city,
                brand_code,
                brand_name,
                store_code,
                sales_mode,
                store_type,
                store_level,
                channel_type,
                order_channel,
                trade_source,
                order_deal_date AS date,
                'key' AS key
            FROM cdm_crm.order_info_detail
            WHERE order_deal_date < date(localtimestamp)
                AND order_deal_date > (SELECT max(date) FROM ads_crm.member_analyse_daily_income_detail)
        ) t1
        FULL JOIN (
            SELECT DISTINCT
                member_type,
                member_newold_type,
                member_level_type,
                member_upgrade_type,
                member_register_type,
                'key' AS key
            FROM cdm_crm.order_info_detail
            WHERE member_type = '会员'
                AND member_newold_type IS NOT NULL
                AND member_level_type IS NOT NULL
                AND member_upgrade_type IS NOT NULL
                AND member_register_type IS NOT NULL
            UNION SELECT DISTINCT
                member_type,
                '' AS member_newold_type,
                '' AS member_level_type,
                '' AS member_upgrade_type,
                '' AS member_register_type,
                'key' AS key
            FROM cdm_crm.order_info_detail
            WHERE member_type = '非会员'
        ) t2 ON t1.key = t2.key
    ), tt AS (
        SELECT
            oid.country,
            oid.sales_area,
            oid.sales_district,
            oid.province,
            oid.city,
            oid.brand_code,
            oid.brand_name,
            oid.store_code,
            oid.sales_mode,
            oid.store_type,
            oid.store_level,
            oid.channel_type,
            oid.order_channel,
            oid.trade_source,
            oid.member_type,
            IF (oid.member_newold_type IS NULL, '', oid.member_newold_type) AS member_newold_type,
            IF (oid.member_level_type IS NULL, '', oid.member_level_type) AS member_level_type,
            IF (oid.member_upgrade_type IS NULL, '', oid.member_upgrade_type) AS member_upgrade_type,
            IF (oid.member_register_type IS NULL, '', oid.member_register_type) AS member_register_type,
            cast(sum(oid.order_fact_amount) AS DECIMAL(18, 3)) AS sales_income,
            cast(sum(oid.order_item_quantity) AS INTEGER) AS sales_item_quantity,
            IF(oid.member_type = '会员', array_agg(oid.member_no), array[]) AS customer_array,
            cast(sum(oid.order_type_num) AS INTEGER) AS order_amount,
            oid.order_deal_date AS date
        FROM cdm_crm.order_info_detail oid
        WHERE oid.order_deal_date > (SELECT max(date) FROM ads_crm.member_analyse_daily_income_detail)
        AND oid.order_deal_date < date(localtimestamp)
        GROUP BY 
            oid.country,
            oid.sales_area,
            oid.sales_district,
            oid.province,
            oid.city,
            oid.brand_code,
            oid.brand_name,
            oid.store_code,
            oid.sales_mode,
            oid.store_type,
            oid.store_level,
            oid.channel_type,
            oid.order_channel,
            oid.trade_source,
            oid.member_type,
            oid.member_newold_type,
            oid.member_level_type,
            oid.member_upgrade_type,
            oid.member_register_type,
            oid.order_deal_date
    ), t AS (
        SELECT
            i.country,
            i.sales_area,
            i.sales_district,
            i.province,
            i.city,
            i.brand_code,
            i.brand_name,
            i.store_code,
            i.sales_mode,
            i.store_type,
            i.store_level,
            i.channel_type,
            i.order_channel,
            i.trade_source,
            i.member_type,
            i.member_newold_type,
            i.member_level_type,
            i.member_upgrade_type,
            i.member_register_type,
            IF (tt.sales_income IS NULL, cast(0 AS DECIMAL(18, 3)), tt.sales_income) AS sales_income,
            IF (tt.sales_item_quantity IS NULL, cast(0 AS INTEGER), tt.sales_item_quantity) AS sales_item_quantity,
            IF (tt.customer_array IS NULL, array[], tt.customer_array) AS customer_array,
            IF (tt.order_amount IS NULL, cast(0 AS INTEGER), tt.order_amount) AS order_amount,
            i.date
        FROM i
        LEFT JOIN tt ON tt.store_code = i.store_code
            AND tt.brand_code = i.brand_code
            AND tt.brand_name = i.brand_name
            AND tt.order_channel = i.order_channel
            AND tt.trade_source = i.trade_source
            AND tt.member_type = i.member_type
            AND tt.member_newold_type = i.member_newold_type
            AND tt.member_level_type = i.member_level_type
            AND tt.member_upgrade_type = i.member_upgrade_type
            AND tt.member_register_type = i.member_register_type
            AND tt.date = i.date
    )
    SELECT
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
        t.member_newold_type,
        t.member_level_type,
        t.member_upgrade_type,
        t.member_register_type,
        t.sales_income,
        t.sales_item_quantity,
        cast(IF(lyst_t.sales_income IS NOT NULL, lyst_t.sales_income, 0) AS DECIMAL(18, 3)),
        t.customer_array,
        t.order_amount,
        t.date,
        cast(year(t.date) AS VARCHAR) AS year,
        date_format(t.date, '%m')     AS month
    FROM t
    LEFT JOIN t lyst_t ON t.city = lyst_t.city
        AND t.brand_code = lyst_t.brand_code
        AND t.brand_name = lyst_t.brand_name
        AND t.store_code = lyst_t.store_code
        AND t.sales_mode = lyst_t.sales_mode
        AND t.store_type = lyst_t.store_type
        AND t.store_level = lyst_t.store_level
        AND t.channel_type = lyst_t.channel_type
        AND t.order_channel = lyst_t.order_channel
        AND t.trade_source = lyst_t.trade_source
        AND t.member_type = lyst_t.member_type
        AND t.member_newold_type = lyst_t.member_newold_type
        AND t.member_level_type = lyst_t.member_level_type
        AND t.member_upgrade_type = lyst_t.member_upgrade_type
        AND t.member_register_type = lyst_t.member_register_type
        AND date(t.date - interval '1' year) = lyst_t.date;
