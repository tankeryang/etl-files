DELETE FROM ods_crm.order_pay_item;


INSERT INTO ods_crm.order_pay_item
  SELECT
    pay_item_id,
    order_id,
    order_from,
    outer_order_no,
    pay_type,
    currency,
    pay_amount,
    coupon_no,
    localtimestamp
  FROM prod_mysql_crm.crm.order_pay_item
  WHERE
    date_format(create_time, '%Y-%m-%d %T') <= date_format(localtimestamp, '%Y-%m-%d %T');
