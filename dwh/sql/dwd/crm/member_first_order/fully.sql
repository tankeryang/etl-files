DELETE FROM dwd_crm.member_first_order;


INSERT INTO dwd_crm.member_first_order
    SELECT
        member_no,
        brand_code,
        MIN(order_deal_time),
        MIN(order_deal_date),
        MIN(order_deal_year_month),
        MIN(order_deal_year),
        MIN(order_deal_month)
    FROM dwd_crm.order_info
    GROUP BY member_no, brand_code;