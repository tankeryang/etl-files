DELETE FROM ads_crm.member_analyse_group_info_detail;


INSERT INTO ads_crm.member_analyse_group_info_detail
    SELECT
        mid.brand_code,
        mid.brand_name,
        mid.member_no,
        -- 客户基础信息
        mid.member_birthday,
        CAST(day((DATE(localtimestamp) - mid.member_birthday) / 365) AS INTEGER) AS member_age,
        mid.member_register_time,
        mid.reg_source,
        mid.member_grade_id,
        -- RFM模型(常用选项)
        mlo.order_deal_time AS last_order_deal_time,
        mlo.order_fact_amount AS last_order_fact_amount,
        CAST(day(DATE(localtimestamp) - DATE(mlo.order_deal_time)) AS INTEGER) AS last_order_deal_time_gap_with_today,
        mfo.order_deal_time AS first_order_deal_time,
        mfo.order_fact_amount AS first_order_fact_amount,
        CAST(day(DATE(localtimestamp) - DATE(mfo.order_deal_time)) AS INTEGER) AS first_order_deal_time_gap_with_today,
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
        CAST(mi.member_score AS DECIMAL(18, 4)),
        -- rfm高级
        CAST(mra.average_order_amount AS DECIMAL(18, 4))      AS average_order_fact_amount,
        CAST(mra.average_purchase_interval AS INTEGER)        AS average_order_deal_time_gap_with_today,
        CAST(mra.total_purchase_frequency AS INTEGER)         AS cumulative_consumed_amount,
        CAST(mra.total_order_fact_amount AS DECIMAL(18, 4))   AS cumulative_order_fact_amount,
        CAST(mra.total_order_count AS INTEGER)                AS cumulative_order_count,
        CAST(mra.total_order_item_quantity AS INTEGER)        AS cumulative_item_count,
        CAST(mra.total_return_frequency AS INTEGER)           AS return_count,
        CAST(mra.total_return_amount AS DECIMAL(18, 4))       AS return_amount,
        CAST(mra.computing_duration AS VARCHAR)               AS rfm_advanced_computing_duration
    FROM cdm_crm.member_info_detail mid
    LEFT JOIN cdm_crm.member_last_order mlo ON mid.brand_code = mlo.brand_code AND mid.member_no = mlo.member_no
    LEFT JOIN cdm_crm.member_first_order mfo ON mid.brand_code = mfo.brand_code AND mid.member_no = mfo.member_no
    LEFT JOIN ods_crm.member_info mi ON mid.brand_code = mi.brand_code AND mid.member_no = mi.member_no
    FULL JOIN cdm_crm.member_product_preference mpp ON mid.brand_code = mpp.brand_code AND mid.member_no = mpp.member_no
    FULL JOIN cdm_crm.member_consumption_preference mcp ON mid.brand_code = mcp.brand_code
        AND mid.member_no = mcp.member_no
    FULL JOIN cdm_crm.member_rfm_tag_advanced mra ON mid.brand_code = mra.brand_code AND mid.member_no = mra.member_no;
