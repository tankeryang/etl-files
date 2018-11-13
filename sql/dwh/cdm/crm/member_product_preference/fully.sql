INSERT INTO cdm_crm.member_product_preference
    WITH mpc AS (
        SELECT brand_code, member_no, main_cate, sum(quantity) AS main_cate_count
        FROM cdm_crm.order_item_detail
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
        AND item_type = 'SALE'
        AND date(order_deal_time) <= date(localtimestamp)
        AND date(order_deal_time) >= date(localtimestamp) - INTERVAL '{compution_duration}' day
        GROUP BY brand_code, member_no, main_cate
    ), mp AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            first_value(main_cate) OVER (
                PARTITION BY brand_code, member_no
                ORDER BY main_cate_count DESC) AS main_cate_preference
        FROM mpc
    ), spc AS (
        SELECT brand_code, member_no, sub_cate, sum(quantity) AS sub_cate_count
        FROM cdm_crm.order_item_detail
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
        AND item_type = 'SALE'
        AND date(order_deal_time) <= date(localtimestamp)
        AND date(order_deal_time) >= date(localtimestamp) - INTERVAL '{compution_duration}' day
        GROUP BY brand_code, member_no, sub_cate
    ), sp AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            first_value(sub_cate) OVER (
                PARTITION BY brand_code, member_no
                ORDER BY sub_cate_count DESC) AS sub_cate_preference
        FROM spc
    ), lpc AS (
        SELECT brand_code, member_no, leaf_cate, sum(quantity) AS leaf_cate_count
        FROM cdm_crm.order_item_detail
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
        AND item_type = 'SALE'
        AND date(order_deal_time) <= date(localtimestamp)
        AND date(order_deal_time) >= date(localtimestamp) - INTERVAL '{compution_duration}' day
        GROUP BY brand_code, member_no, leaf_cate
    ), lp AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            first_value(leaf_cate) OVER (
                PARTITION BY brand_code, member_no
                ORDER BY leaf_cate_count DESC) AS leaf_cate_preference
        FROM lpc
    ), lnpc AS (
        SELECT brand_code, member_no, lining, sum(quantity) AS lining_count
        FROM cdm_crm.order_item_detail
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
        AND item_type = 'SALE'
        AND date(order_deal_time) <= date(localtimestamp)
        AND date(order_deal_time) >= date(localtimestamp) - INTERVAL '{compution_duration}' day
        GROUP BY brand_code, member_no, lining
    ), lnp AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            first_value(lining) OVER (
                PARTITION BY brand_code, member_no
                ORDER BY lining_count DESC) AS lining_preference
        FROM lnpc 
    ), cpc AS (
        SELECT brand_code, member_no, product_color_code, sum(quantity) AS product_color_code_count
        FROM cdm_crm.order_item_detail
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
        AND item_type = 'SALE'
        AND date(order_deal_time) <= date(localtimestamp)
        AND date(order_deal_time) >= date(localtimestamp) - INTERVAL '{compution_duration}' day
        GROUP BY brand_code, member_no, product_color_code
    ), cp AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            first_value(product_color_code) OVER (
                PARTITION BY brand_code, member_no
                ORDER BY product_color_code_count DESC) AS color_preference
        FROM cpc
    ), szpc AS (
        SELECT brand_code, member_no, product_size_code, sum(quantity) AS product_size_code_count
        FROM cdm_crm.order_item_detail
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
        AND item_type = 'SALE'
        AND date(order_deal_time) <= date(localtimestamp)
        AND date(order_deal_time) >= date(localtimestamp) - INTERVAL '{compution_duration}' day
        GROUP BY brand_code, member_no, product_size_code
    ), szp AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            first_value(product_size_code) OVER (
                PARTITION BY brand_code, member_no
                ORDER BY product_size_code_count DESC) AS size_preference
        FROM szpc
    )
    SELECT
        mi.brand_code,
        mi.member_no,
        mp.main_cate_preference,
        sp.sub_cate_preference,
        lp.leaf_cate_preference,
        NULL AS product_group_preference,
        lnp.lining_preference,
        NULL AS price_baseline_preference,
        NULL AS outline_preference,
        cp.color_preference,
        szp.size_preference,
        '{compution_duration}'
    FROM ods_crm.member_info mi
    LEFT JOIN mp ON mi.brand_code = mp.brand_code AND mi.member_no = mp.member_no
    LEFT JOIN sp ON mi.brand_code = sp.brand_code AND mi.member_no = sp.member_no
    LEFT JOIN lp ON mi.brand_code = lp.brand_code AND mi.member_no = lp.member_no
    LEFT JOIN cp ON mi.brand_code = cp.brand_code AND mi.member_no = cp.member_no
    LEFT JOIN lnp ON mi.brand_code = lnp.brand_code AND mi.member_no = lnp.member_no
    LEFT JOIN szp ON mi.brand_code = szp.brand_code AND mi.member_no = szp.member_no;
