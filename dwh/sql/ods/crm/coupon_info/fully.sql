DELETE FROM ods_crm.coupon_info;


INSERT INTO ods_crm.coupon_info
    SELECT
        ci.member_no,
        ci.brand_code,
        ci.coupon_no,
        ci.coupon_template_no,
        ct.coupon_template_name,
        CAST(ci.coupon_status AS VARCHAR),
        ci.coupon_category,
        CAST(ci.coupon_discount AS DECIMAL(18, 2)),
        CAST(ci.coupon_denomination AS DECIMAL(18, 2)),
        ci.coupon_type,
        ci.coupon_type_detail,
        ci.batch_time,
        CAST(ci.coupon_batch_status AS VARCHAR),
        ci.coupon_start_time,
        ci.coupon_end_time,
        localtimestamp
    FROM prod_mysql_crm.crm.coupon_info ci
    LEFT JOIN prod_mysql_crm.crm.coupon_template ct
    ON ci.coupon_template_no = ct.coupon_template_no;
