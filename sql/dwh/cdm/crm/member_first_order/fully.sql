--这里有个坑，第一张订单数据不正确，会导致后面活跃客户数据对不上！！！
DELETE FROM cdm_crm.member_first_order;


INSERT INTO cdm_crm.member_first_order
    SELECT
        member_no,
        min(order_deal_time) AS order_deal_time
    FROM ods_crm.order_info
    GROUP BY member_no;
