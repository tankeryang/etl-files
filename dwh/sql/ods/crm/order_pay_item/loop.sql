-- COST 7:00 +/- 0:10/0:30 min

INSERT INTO ods_crm.order_pay_item
    SELECT DISTINCT
        opi.pay_item_id,
        opi.order_id,
        opi.order_from,
        opi.outer_order_no,
        opi.pay_type,
        opi.currency,
        opi.pay_amount,
        IF(opi.coupon_no IS NULL, '', opi.coupon_no),
        oi.pay_time,
        localtimestamp
    FROM prod_mysql_crm.crm.order_pay_item opi
    INNER JOIN prod_mysql_crm.crm.order_info oi ON oi.outer_order_no = opi.outer_order_no
    WHERE oi.pay_time > (SELECT MAX(order_deal_time) FROM ods_crm.order_pay_item)
        AND oi.pay_time < DATE_PARSE(DATE_FORMAT(localtimestamp, '%Y-%m-%d 00:00:00'), '%Y-%m-%d %T')
        AND oi.brand_code IN ('2', '3', '6');

