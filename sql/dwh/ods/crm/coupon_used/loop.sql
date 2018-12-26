INSERT INTO ods_crm.coupon_used
    SELECT
        coupon_no,
        status,
        outer_order_no,
        member_no,
        brand_code,
        order_time,
        localtimestamp
    FROM prod_mysql_crm.crm.coupon_used
    WHERE order_time < localtimestamp
        AND order_time > (SELECT max(order_time) FROM ods_crm.coupon_used);
