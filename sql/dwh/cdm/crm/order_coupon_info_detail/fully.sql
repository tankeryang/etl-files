DELETE FROM cdm_crm.order_coupon_info_detail;


INSERT INTO cdm_crm.order_coupon_info_detail
    SELECT
        cu.outer_order_no,
        IF(array_agg(cu.coupon_no) != array[''], array_agg(cu.coupon_no), NULL),
        ci.coupon_category,
        cast(sum(ci.coupon_denomination) AS DECIMAL(18, 2))
    FROM ods_crm.coupon_used cu
    LEFT JOIN ods_crm.coupon_info ci ON cu.coupon_no = ci.coupon_no
    GROUP BY cu.outer_order_no, ci.coupon_category;
