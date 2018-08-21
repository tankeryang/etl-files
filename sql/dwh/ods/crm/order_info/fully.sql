-- COST 1:20
INSERT INTO ods_crm.order_info
  SELECT
    order_id,
    outer_order_no,
    store_code,
    pay_time AS order_deal_time,
    member_no,
    order_grade,
    order_item_quantity,
    order_amount,
    order_fact_amount,
    order_status,
    outer_return_order_no,
    localtimestamp
  FROM prod_mysql_crm.crm.order_info
  WHERE
    date_format(create_time, '%Y-%m-%d %T') <= date_format(localtimestamp, '%Y-%m-%d %T');
