DELETE FROM cdm_crm.member_coupon_info_detail;


INSERT INTO cdm_crm.member_coupon_info_detail
    SELECT
        member_no,
        brand_code,
        CAST(COUNT(DISTINCT coupon_no) AS INTEGER) AS coupon_amount,
        coupon_template_no,
        coupon_status,
        coupon_category,
        coupon_discount,
        coupon_denomination,
        coupon_type,
        coupon_type_detail,
        coupon_batch_time,
        coupon_batch_status,
        coupon_start_time,
        coupon_end_time,
        localtimestamp
    FROM ods_crm.coupon_info
    GROUP BY
        member_no,
        brand_code,
        coupon_template_no,
        coupon_status,
        coupon_category,
        coupon_discount,
        coupon_denomination,
        coupon_type,
        coupon_type_detail,
        coupon_batch_time,
        coupon_batch_status,
        coupon_start_time,
        coupon_end_time;
