INSERT INTO cdm_crm.member_structure_order_info (
    computing_until_month,
    computing_duration,
    order_id,
    outer_order_no,
    store_code,
    order_deal_time,
    member_no,
    order_grade,
    order_item_quantity,
    order_amount,
    order_fact_amount,
    order_status,
    outer_return_order_no
    )
    -----------1, 3, 6, 12月时间段------------------------------------------------------------------------------------------------
    WITH
        order_info_range AS (
            SELECT *
            FROM member_structure_order_info_range
            WHERE computing_until_month = date_format(CURRENT_DATE + INTERVAL '-1' MONTH, '%Y-%m')
                AND computing_duration = CAST('{computing_duration}' AS INTEGER)
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
        --union all order_info, member_purchase_from_return
        union_all_order_info_n_member_purchase_from_return AS (
        SELECT *
        FROM order_info
        UNION ALL
        SELECT roi.*
        FROM return_order_info roi
        WHERE roi.order_id IN (SELECT order_id
                                FROM member_purchase_from_return)
        )
    SELECT
        date_format(CURRENT_DATE + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
        CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
        order_id,
        outer_order_no,
        store_code,
        order_deal_time,
        member_no,
        order_grade,
        order_item_quantity,
        order_amount,
        order_fact_amount,
        order_status,
        outer_return_order_no
    FROM union_all_order_info_n_member_purchase_from_return;