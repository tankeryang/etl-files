DELETE FROM cdm_crm.order_coupon_info_detail;


INSERT INTO cdm_crm.order_coupon_info_detail
    WITH cu AS (
        SELECT
            cu_.outer_order_no,
            ci.coupon_category,
            IF(ARRAY_AGG(cu_.coupon_no) != array[''], ARRAY_AGG(cu_.coupon_no), NULL) AS coupon_no_array
        FROM ods_crm.coupon_used cu_
        LEFT JOIN ods_crm.coupon_info ci ON cu_.coupon_no = ci.coupon_no
        GROUP BY cu_.outer_order_no, ci.coupon_category
    ), cu_t AS (
        SELECT
            cu.outer_order_no,
            cu.coupon_category,
            cu.coupon_no_array,
            oi.order_deal_time
        FROM cu
        LEFT JOIN ods_crm.order_info oi
        ON cu.outer_order_no = oi.outer_order_no
    )
    SELECT
        oit.outer_order_no,
        cu_t.coupon_no_array,
        cu_t.coupon_category,
        CAST(SUM(oit.sub_coupon_amount) AS DECIMAL(18, 2)),
        cu_t.order_deal_time,
        localtimestamp
    FROM ods_crm.order_item oit
    LEFT JOIN cu_t ON cu_t.outer_order_no = oit.outer_order_no
    WHERE cu_t.order_deal_time < DATE_PARSE(DATE_FORMAT(localtimestamp, '%Y-%m-%d 00:00:00'), '%Y-%m-%d %T')
    GROUP BY oit.outer_order_no, cu_t.coupon_category, cu_t.coupon_no_array, cu_t.order_deal_time;
