INSERT INTO cdm_crm.order_coupon_info_detail
    WITH cu AS (
        SELECT
            outer_order_no,
            IF(ARRAY_AGG(coupon_no) != array[''], ARRAY_AGG(coupon_no), NULL) AS coupon_no_array,
            order_time
        FROM ods_crm.coupon_used
        GROUP BY outer_order_no, order_time
    )
    SELECT
        oi.outer_order_no,
        cu.coupon_no_array,
        'Cash',
        CAST(SUM(oi.sub_coupon_amount) AS DECIMAL(18, 2)),
        cu.order_time,
        localtimestamp
    FROM ods_crm.order_item oi
    LEFT JOIN cu ON cu.outer_order_no = oi.outer_order_no
    WHERE cu.order_time > (SELECT MAX(order_time) FROM cdm_crm.order_coupon_info_detail)
        AND cu.order_time < DATE_PARSE(DATE_FORMAT(localtimestamp, '%Y-%m-%d 00:00:00'), '%Y-%m-%d %T')
    GROUP BY oi.outer_order_no, cu.coupon_no_array, cu.order_time;
