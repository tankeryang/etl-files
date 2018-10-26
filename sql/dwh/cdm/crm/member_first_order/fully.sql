DELETE FROM cdm_crm.member_first_order;


INSERT INTO cdm_crm.member_first_order
    SELECT
        member_no,
        brand_code,
        min(order_deal_time) AS order_deal_time
    FROM ods_crm.order_info
    GROUP BY member_no, brand_code;
