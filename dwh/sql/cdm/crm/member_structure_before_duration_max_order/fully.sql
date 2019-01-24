INSERT INTO cdm_crm.member_structure_before_duration_max_order (
    computing_until_month,
    computing_duration,
    channel_type,
    sales_area,
    store_region,
    member_no,
    max_order_deal_time
    )
    -- 会员购买渠道、购买所属销售区域、行政区域、等级、新老客户、最近购买时间间隔、累计消费金额、订单ID、会员ID
    -----------1, 3, 6, 12月时间段------------------------------------------------------------------------------------------------
    WITH
        order_info_range AS (
            SELECT *
            FROM ods_crm.order_info
            WHERE cast(member_no AS INTEGER) > 0 AND
                order_deal_time IS NOT NULL AND
                order_deal_time <
                date_trunc('month', date_add('month', -1 * CAST('{computing_duration}' AS INTEGER), DATE('{c_date}')))
        ),
        --0、正价单
        order_info AS (
            SELECT *
            FROM order_info_range
            WHERE order_fact_amount >= 0
        ),
        --负价单范围
        return_order_info AS (
            SELECT *
            FROM order_info_range
            WHERE order_fact_amount < 0
        ),
        --会员退货+新买商品的单
        member_purchase_from_return AS (
            SELECT DISTINCT roi.order_id
            FROM return_order_info roi, ods_crm.order_item oit
            WHERE roi.order_id = oit.order_id AND
                oit.quantity > 0
        ),
        ----订单(正价、退换货并购买等）
        union_all_order_info_n_member_purchase_from_return AS (
        SELECT *
        FROM order_info
        UNION ALL
        SELECT roi.*
        FROM return_order_info roi
        WHERE roi.order_id IN (SELECT order_id
                                FROM member_purchase_from_return)
        ),
        --全渠道、区域下的上月、季度、半年、年等之前等最近购买时间统计
        last_duration_max_order AS (
            SELECT
            member_no,
            max(order_deal_time) AS max_order_deal_time
            FROM union_all_order_info_n_member_purchase_from_return
            GROUP BY member_no
        ),
        --按渠道分组统计
        last_duration_channel_type_max_order AS (
            SELECT
            si.channel_type,
            oi.member_no,
            max(oi.order_deal_time) AS max_order_deal_time
            FROM union_all_order_info_n_member_purchase_from_return oi, ods_crm.store_info si
            WHERE oi.store_code = si.store_code
            GROUP BY si.channel_type, oi.member_no
        ), --si.city                                                                     AS store_region
    --按销售区域分组统计
        last_duration_sales_area_max_order AS (
            SELECT
            si.sales_area,
            oi.member_no,
            max(oi.order_deal_time) AS max_order_deal_time
            FROM union_all_order_info_n_member_purchase_from_return oi, ods_crm.store_info si
            WHERE oi.store_code = si.store_code
            GROUP BY si.sales_area, oi.member_no
        ),
        --按区域分组统计
        last_duration_store_region_max_order AS (
            SELECT
            si.city                 AS store_region,
            oi.member_no,
            max(oi.order_deal_time) AS max_order_deal_time
            FROM union_all_order_info_n_member_purchase_from_return oi, ods_crm.store_info si
            WHERE oi.store_code = si.store_code
            GROUP BY si.city, oi.member_no
        ),
        --按渠道、销售区域分组统计
        last_duration_channel_type_sales_area_max_order AS (
            SELECT
            si.channel_type,
            si.sales_area,
            oi.member_no,
            max(oi.order_deal_time) AS max_order_deal_time
            FROM union_all_order_info_n_member_purchase_from_return oi, ods_crm.store_info si
            WHERE oi.store_code = si.store_code
            GROUP BY si.channel_type, si.sales_area, member_no
        ),
        --按渠道、区域分组统计
        last_duration_channel_type_store_region_max_order AS (
            SELECT
            si.channel_type,
            si.city                 AS store_region,
            oi.member_no,
            max(oi.order_deal_time) AS max_order_deal_time
            FROM union_all_order_info_n_member_purchase_from_return oi, ods_crm.store_info si
            WHERE oi.store_code = si.store_code
            GROUP BY si.channel_type, si.city, oi.member_no
        ),
        --按销售区域、区域分组统计
        last_duration_sales_area_store_region_max_order AS (
            SELECT
            si.sales_area,
            si.city                 AS store_region,
            oi.member_no,
            max(oi.order_deal_time) AS max_order_deal_time
            FROM union_all_order_info_n_member_purchase_from_return oi, ods_crm.store_info si
            WHERE oi.store_code = si.store_code
            GROUP BY si.sales_area, si.city, oi.member_no
        ),
        --按渠道、销售区域、区域分组统计
        last_duration_channel_type_sales_area_store_region_max_order AS (
            SELECT
            si.channel_type,
            si.sales_area,
            si.city                 AS store_region,
            oi.member_no,
            max(oi.order_deal_time) AS max_order_deal_time
            FROM union_all_order_info_n_member_purchase_from_return oi, ods_crm.store_info si
            WHERE oi.store_code = si.store_code
            GROUP BY si.channel_type, si.sales_area, si.city, oi.member_no
        )
    SELECT
        date_format(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
        CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
        NULL                                                     AS channel_type,
        NULL                                                     AS sales_area,
        NULL                                                     AS store_region,
        member_no,
        max_order_deal_time
    FROM last_duration_max_order
    UNION ALL
    SELECT
        date_format(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
        CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
        channel_type,
        NULL                                                     AS sales_area,
        NULL                                                     AS store_region,
        member_no,
        max_order_deal_time
    FROM last_duration_channel_type_max_order
    UNION ALL
    SELECT
        date_format(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
        CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
        NULL                                                     AS channel_type,
        sales_area,
        NULL                                                     AS store_region,
        member_no,
        max_order_deal_time
    FROM last_duration_sales_area_max_order
    UNION ALL
    SELECT
        date_format(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
        CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
        NULL                                                     AS channel_type,
        NULL                                                     AS sales_area,
        store_region,
        member_no,
        max_order_deal_time
    FROM last_duration_store_region_max_order
    UNION ALL
    SELECT
        date_format(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
        CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
        channel_type,
        sales_area,
        NULL                                                     AS store_region,
        member_no,
        max_order_deal_time
    FROM last_duration_channel_type_sales_area_max_order
    UNION ALL
    SELECT
        date_format(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
        CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
        channel_type,
        NULL                                                     AS sales_area,
        store_region,
        member_no,
        max_order_deal_time
    FROM last_duration_channel_type_store_region_max_order
    UNION ALL
    SELECT
        date_format(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
        CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
        NULL                                                     AS channel_type,
        sales_area,
        store_region,
        member_no,
        max_order_deal_time
    FROM last_duration_sales_area_store_region_max_order
    UNION ALL
    SELECT
        date_format(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
        CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
        channel_type,
        sales_area,
        store_region,
        member_no,
        max_order_deal_time
    FROM last_duration_channel_type_sales_area_store_region_max_order;