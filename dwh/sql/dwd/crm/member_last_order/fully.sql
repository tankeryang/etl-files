DELETE FROM dwd_crm.member_last_order;


INSERT INTO dwd_crm.member_last_order
    SELECT
        member_no,
        brand_code,
        MAX(order_deal_time),
        MAX(order_deal_date),
        MAX(order_deal_year_month),
        MAX(order_deal_year),
        MAX(order_deal_month)
    FROM dwd_crm.order_info
    GROUP BY member_no, brand_code;
