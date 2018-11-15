DELETE FROM ads_crm.member_analyse_group_info_detail;


INSERT INTO ads_crm.member_analyse_group_info_detail
    SELECT
        mid.brand_code,
        mid.brand_name,
        mid.member_no,
        -- 客户基础信息
        mid.member_birthday,
        cast(day((date(localtimestamp) - mid.member_birthday) / 365) AS INTEGER) AS member_age,
        mid.member_register_time,
        mid.reg_source,
        mid.member_grade_id,
        -- RFM模型(常用选项)
        mlo.order_deal_time AS last_order_deal_time,
        mlo.order_fact_amount AS last_order_fact_amount,
        cast(day(date(localtimestamp) - date(mlo.order_deal_time)) AS INTEGER) AS last_order_deal_time_gap_with_today,
        mfo.order_deal_time AS first_order_deal_time,
        mfo.order_fact_amount AS first_order_fact_amount,
        cast(day(date(localtimestamp) - date(mfo.order_deal_time)) AS INTEGER) AS first_order_deal_time_gap_with_today,
        -- 产品属性偏好
        mpp.main_cate_preference,
        mpp.sub_cate_preference,
        mpp.leaf_cate_preference,
        mpp.product_group_preference,
        mpp.lining_preference,
        mpp.price_baseline_preference,
        mpp.outline_preference,
        mpp.color_preference,
        mpp.size_preference,
        mpp.computing_duration,
        -- 购物偏好
        mcp.store_preference,
        mcp.pay_type_preference,
        mcp.related_rate_preference,
        mcp.discount_rate_preference,
        mcp.coupon_discount_rate_preference,
        mcp.uncoupon_discount_rate_preference,
        mcp.computing_duration,
        -- 会员相关
        mi.member_score,
        -- rfm高级
        cast(mra.average_order_amount AS DECIMAL(18, 4))      AS average_order_fact_amount,
        cast(mra.average_purchase_interval AS DECIMAL(18, 4)) AS average_order_deal_time_gap_with_today,
        cast(mra.total_purchase_frequency AS INTEGER)         AS cumulated_consumed_amount,
        cast(mra.total_order_fact_amount AS DECIMAL(18, 4))   AS cumulated_order_fact_amount,
        cast(mra.total_order_count AS INTEGER)                AS cumulated_order_count,
        cast(mra.total_order_item_quantity AS INTEGER)        AS cumulated_item_count,
        cast(mra.total_return_frequency AS INTEGER)           AS return_count,
        cast(mra.total_return_amount AS DECIMAL(18, 4))       AS return_amount
    FROM cdm_crm.member_info_detail mid
    LEFT JOIN cdm_crm.member_last_order mlo ON mid.brand_code = mlo.brand_code AND mid.member_no = mlo.member_no
    LEFT JOIN cdm_crm.member_first_order mfo ON mid.brand_code = mfo.brand_code AND mid.member_no = mfo.member_no
    LEFT JOIN ods_crm.member_info mi ON mid.brand_code = mi.brand_code AND mid.member_no = mi.member_no
    LEFT JOIN cdm_crm.member_product_preference mpp ON mid.brand_code = mpp.brand_code AND mid.member_no = mpp.member_no
    LEFT JOIN cdm_crm.member_consumption_preference mcp ON mid.brand_code = mcp.brand_code
        AND mid.member_no = mcp.member_no
    LEFT JOIN cdm_crm.member_rfm_tag_advanced mra ON mid.brand_code = mra.brand_code AND mid.member_no = mra.member_no;
