-- CONSIDER IF USE IT OR NOT
-- COST 9:00 +/- 0:20/0:30 min

INSERT INTO ods_crm.order_info
    SELECT
        order_id,
        outer_order_no,
        CAST(order_from AS VARCHAR),
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
    WHERE order_status = 'PAYED'
        AND pay_time > (SELECT MAX(order_deal_time) FROM ods_crm.order_info)
        AND pay_time < DATE_PARSE(DATE_FORMAT(localtimestamp, '%Y-%m-%d 00:00:00'), '%Y-%m-%d %T')
        AND brand_code IN ('2', '3', '6');
