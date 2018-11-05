DELETE FROM ods_crm.coupon_info;


INSERT INTO ods_crm.coupon_info
    SELECT
        coupon_no,
        coupon_start_time,
        coupon_end_time,
        cast(coupon_status AS VARCHAR),
        cast(coupon_batch_status AS VARCHAR),
        member_no,
        brand_code,
        coupon_type,
        coupon_type_detail,
        coupon_category,
        cast(coupon_denomination AS DECIMAL(18, 2)),
        cast(coupon_discount AS DECIMAL(18, 2)),
        localtimestamp
    FROM prod_mysql_crm.crm.coupon_info;
