DELETE FROM cdm_crm.member_structure_duration_member_recency;


INSERT INTO cdm_crm.member_structure_duration_member_recency (
    computing_until_month,
    computing_duration,
    member_no,
    recency
)
    --各时间段里客户的recency
    SELECT
        computing_until_month,
        computing_duration,
        member_no,
        date_diff('day', DATE(MAX(order_deal_time)), date_trunc('month', DATE('{c_date}')) + INTERVAL '-1' DAY) AS recency
    FROM member_structure_duration_order_store
    GROUP BY computing_until_month, computing_duration, member_no;