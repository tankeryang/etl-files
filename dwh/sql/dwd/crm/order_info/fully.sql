DELETE FROM dwd_crm.order_info;


INSERT INTO dwd_crm.order_info
    SELECT
        order_id,
        outer_order_no,
        order_from,
        trade_source,
        brand_code,
        store_code,
        member_no,
        order_grade,
        order_item_quantity,
        order_amount,
        order_fact_amount,
        order_status,
        outer_return_order_no,
        IF(order_deal_time IS NOT NULL, order_deal_time, create_time),
        DATE(IF(order_deal_time IS NOT NULL, order_deal_time, create_time)),
        DATE_FORMAT(IF(order_deal_time IS NOT NULL, order_deal_time, create_time), '%Y-%m'),
        CAST(YEAR(IF(order_deal_time IS NOT NULL, order_deal_time, create_time)) AS INTEGER),
        CAST(MONTH(IF(order_deal_time IS NOT NULL, order_deal_time, create_time)) AS INTEGER),
        create_time
    FROM ods_crm.order_info;
