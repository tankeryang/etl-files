DELETE FROM ads_crm.member_coupon_order_info_detail;


INSERT INTO ads_crm.member_coupon_order_info_detail
    SELECT
        ci.brand_code,
        mi.member_no,
        mi.member_name,
        mi.member_mobile,
        mi.member_wechat_id,
        mi.store_code,
        mi.store_name,
        ci.coupon_no,
        ci.coupon_name,
        ci.coupon_passcode,
        ci.coupon_status,
        ci.coupon_batch_time,
        ci.coupon_batch_date,
        ci.coupon_start_time,
        ci.coupon_start_date,
        ci.coupon_end_time,
        ci.coupon_end_date,
        ci.coupon_template_no,
        ci.coupon_template_name,
        ci.coupon_category,
        ci.coupon_type,
        ci.coupon_type_detail,
        ci.coupon_denomination,
        ci.coupon_used_time,
        ci.coupon_used_date,
        ci.coupon_used_order_no,
        oi.store_code,
        oi.store_name,
        oi.trade_source,
        oi.member_grade_id,
        CAST(oi.order_amount AS DECIMAL(18, 2)),
        CAST(oi.order_fact_amount AS DECIMAL(18, 2)),
        CAST(oi.order_fact_amount_include_coupon AS DECIMAL(18, 2)),
        CAST(COALESCE(TRY(oi.order_fact_amount / oi.order_amount), 0) AS DECIMAL(18, 2)),
        oi.order_item_quantity
    FROM cdm_crm.member_coupon_info_detail ci
    LEFT JOIN cdm_crm.member_info_detail mi ON ci.member_no = mi.member_no
        AND ci.brand_code = mi.brand_code
    LEFT JOIN cdm_crm.order_info_detail oi ON ci.member_no = oi.member_no
        AND ci.brand_code = mi.brand_code
        AND ci.coupon_used_order_no = oi.outer_order_no;
