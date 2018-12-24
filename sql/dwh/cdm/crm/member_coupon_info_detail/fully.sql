DELETE FROM cdm_crm.member_coupon_info_detail;


INSERT INTO cdm_crm.member_coupon_info_detail
    SELECT
        ci.member_no,
        ci.brand_code,
        ci.coupon_no,
        ci.coupon_template_no,
        ci.coupon_template_name,
        ci.coupon_status,
        ci.coupon_category,
        ci.coupon_discount,
        ci.coupon_denomination,
        ci.coupon_type,
        ci.coupon_type_detail,
        ci.coupon_batch_time,
        ci.coupon_batch_status,
        ci.coupon_start_time,
        ci.coupon_end_time,
        cu.outer_order_no,
        cu.order_time,
        localtimestamp
    FROM ods_crm.coupon_info ci
    LEFT JOIN ods_crm.coupon_used cu
    ON ci.member_no = cu.member_no
        AND ci.brand_code = cu.brand_code
        AND ci.coupon_no = cu.coupon_no;
