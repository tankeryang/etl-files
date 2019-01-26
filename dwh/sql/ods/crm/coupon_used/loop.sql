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
    WHERE order_time > (SELECT MAX(order_time) FROM ods_crm.coupon_used)
        AND order_time < DATE_PARSE(DATE_FORMAT(localtimestamp, '%Y-%m-%d 00:00:00'), '%Y-%m-%d %T')
        AND brand_code IN ('2', '3', '6');
