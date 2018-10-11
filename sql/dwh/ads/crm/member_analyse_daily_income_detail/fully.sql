DELETE FROM ads_crm.member_analyse_daily_income_detail;


INSERT INTO ads_crm.member_analyse_daily_income_detail
    WITH t AS (
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
            oid.member_type,
            oid.member_newold_type,
            oid.member_level_type,
            oid.member_upgrade_type,
            oid.member_register_type,
            cast(sum(oid.order_fact_amount) AS DECIMAL(18, 3)) AS sales_income,
            cast(sum(oid.order_item_quantity) AS INTEGER) AS sales_item_quantity,
            IF(oid.member_type = '会员', array_agg(oid.member_no), array[]) AS customer_array,
            cast(count(oid.outer_order_no) AS INTEGER) AS order_amount,
            date(oid.order_deal_time) AS date
        FROM cdm_crm.order_info_detail oid
        WHERE oid.order_amount > 0
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
            oid.member_type,
            oid.member_grade_id,
            oid.member_newold_type,
            oid.member_level_type,
            oid.member_upgrade_type,
            oid.member_register_type,
            date(oid.last_grade_change_time),
            date(oid.order_deal_time)
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
        t.date
    FROM t
    LEFT JOIN t lyst_t
    ON t.city = lyst_t.city
    AND t.brand_code = lyst_t.brand_code
    AND t.brand_name = lyst_t.brand_name
    AND t.store_code = lyst_t.store_code
    AND t.sales_mode = lyst_t.sales_mode
    AND t.store_type = lyst_t.store_type
    AND t.store_level = lyst_t.store_level
    AND t.channel_type = lyst_t.channel_type
    AND t.order_channel = lyst_t.order_channel
    AND t.member_type = lyst_t.member_type
    AND t.member_newold_type = lyst_t.member_newold_type
    AND t.member_level_type = lyst_t.member_level_type
    AND t.member_upgrade_type = lyst_t.member_upgrade_type
    AND t.member_register_type = lyst_t.member_register_type
    AND date(t.date - interval '1' year) = lyst_t.date;
