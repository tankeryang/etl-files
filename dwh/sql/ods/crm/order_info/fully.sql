DELETE FROM ods_crm.order_info;


INSERT INTO ods_crm.order_info
    SELECT
        order_id,
        outer_order_no,
        cast(order_from AS VARCHAR),
        trade_source,
        brand_code,
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
    WHERE date(pay_time) < date(localtimestamp)
    AND order_status = 'PAYED';