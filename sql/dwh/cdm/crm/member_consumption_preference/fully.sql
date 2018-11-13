INSERT INTO cdm_crm.member_consumption_preference
    WITH spc AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            store_code,
            count(outer_order_no) AS store_code_count
        FROM cdm_crm.order_info_detail
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
        AND date(order_deal_time) <= date(localtimestamp)
        AND date(order_deal_time) >= date(localtimestamp) - INTERVAL '{compution_duration}' day
        GROUP BY brand_code, member_no, store_code
    ), sp AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            first_value(store_code) OVER (
                PARTITION BY brand_code, member_no
                ORDER BY store_code_count DESC) AS store_preference
        FROM spc
    ), ppc AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            order_pay_type,
            count(outer_order_no) AS pay_type_count
        FROM cdm_crm.order_info_detail
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
        AND date(order_deal_time) <= date(localtimestamp)
        AND date(order_deal_time) >= date(localtimestamp) - INTERVAL '{compution_duration}' day
        GROUP BY brand_code, member_no, order_pay_type
    ), pp AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            first_value(order_pay_type) OVER (
                PARTITION BY brand_code, member_no
                ORDER BY pay_type_count DESC) AS pay_type_preference
        FROM ppc
    ), dpc AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            IF(order_amount != 0, order_fact_amount / order_amount, 0) AS discount_rate,
            count(outer_order_no) AS discount_rate_count
        FROM cdm_crm.order_info_detail
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
        AND date(order_deal_time) <= date(localtimestamp)
        AND date(order_deal_time) >= date(localtimestamp) - INTERVAL '{compution_duration}' day
        GROUP BY brand_code, member_no, order_fact_amount, order_amount
    ), dp AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            first_value(discount_rate) OVER (
                PARTITION BY brand_code, member_no
                ORDER BY discount_rate_count DESC) AS discount_rate_preference
        FROM dpc
    ), cdpc AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            IF(order_amount != 0, order_fact_amount_include_coupon / order_amount, 0) AS coupon_discount_rate,
            count(outer_order_no) AS coupon_discount_rate_count
        FROM cdm_crm.order_info_detail
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
        AND date(order_deal_time) <= date(localtimestamp)
        AND date(order_deal_time) >= date(localtimestamp) - INTERVAL '{compution_duration}' day
        GROUP BY brand_code, member_no, order_fact_amount_include_coupon, order_amount
    ), cdp AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            first_value(coupon_discount_rate) OVER (
                PARTITION BY brand_code, member_no
                ORDER BY coupon_discount_rate_count DESC) AS coupon_discount_rate_preference
        FROM cdpc
    ), rr AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            cast(sum(order_item_auantity) / count(outer_order_no) AS DECIMAL(18,4)) AS related_rate,
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
        AND date(order_deal_time) <= date(localtimestamp)
        AND date(order_deal_time) >= date(localtimestamp) - INTERVAL '{compution_duration}' day
        GROUP BY brand_code, member_no
    )
    SELECT
        mi.brand_code,
        mi.member_no,
        sp.store_preference,
        pp.pay_type_preference,
        dp.discount_rate_preference,
        cdp.coupon_discount_rate_preference,
        dp.discount_rate_preference AS uncoupon_discount_rate_preference,
        '{computing_duration}'
    FROM ods_crm.member_info
    LEFT JOIN sp ON mi.brand_code = sp.brand_code AND mi.member_no = sp.member_no
    LEFT JOIN pp ON mi.brand_code = pp.brand_code AND mi.member_no = pp.member_no
    LEFT JOIN dp ON mi.brand_code = dp.brand_code AND mi.member_no = dp.member_no
    LEFT JOIN cdp ON mi.brand_code = cdp.brand_code AND mi.member_no = cdp.member_no
    LEFT JOIN rr ON mi.brand_code = rr.brand_code AND mi.member_no = rr.member_no;
