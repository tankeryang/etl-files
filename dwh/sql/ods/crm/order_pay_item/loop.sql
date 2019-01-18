-- COST 7:00 +/- 0:10/0:30 min

INSERT INTO ods_crm.order_pay_item
    SELECT
        pay_item_id,
        order_id,
        order_from,
        outer_order_no,
        pay_type,
        currency,
        pay_amount,
        IF (coupon_no IS NULL, '', coupon_no),
        localtimestamp
    FROM prod_mysql_crm.crm.order_pay_item
    WHERE
        date_format(create_time, '%Y-%m-%d %T') > (
        SELECT date_format(max(create_time), '%Y-%m-%d %T')
        FROM ods_crm.order_pay_item
        )
        AND date(create_time) < date(localtimestamp);