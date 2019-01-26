DELETE FROM cdm_crm.order_coupon_info_detail;


INSERT INTO cdm_crm.order_coupon_info_detail
    SELECT
        cu.outer_order_no,
        IF(ARRAY_AGG(cu.coupon_no) != array[''], ARRAY_AGG(cu.coupon_no), NULL),
        ci.coupon_category,
        CAST(SUM(ci.coupon_denomination) AS DECIMAL(18, 2)),
        cu.order_time,
        localtimestamp
    FROM ods_crm.coupon_used cu
    LEFT JOIN ods_crm.coupon_info ci ON cu.coupon_no = ci.coupon_no
    WHERE cu.order_time < DATE_PARSE(DATE_FORMAT(localtimestamp, '%Y-%m-%d 00:00:00'), '%Y-%m-%d %T')
    GROUP BY cu.outer_order_no, ci.coupon_category;
