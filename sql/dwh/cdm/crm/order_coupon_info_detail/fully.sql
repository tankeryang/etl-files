DELETE FROM cdm_crm.order_coupon_info_detail;


INSERT INTO cdm_crm.order_coupon_info_detail
    SELECT
        opi.outer_order_no,
        opi.pay_type,
        IF(array_agg(opi.coupon_no) != array[''], array_agg(opi.coupon_no), NULL),
        ci.coupon_category,
        cast(sum(ci.coupon_denomination) AS DECIMAL(18, 2))
    FROM ods_crm.order_pay_item opi
    LEFT JOIN ods_crm.coupon_info ci ON opi.coupon_no = ci.coupon_no
    GROUP BY opi.outer_order_no, opi.pay_type, ci.coupon_category;
