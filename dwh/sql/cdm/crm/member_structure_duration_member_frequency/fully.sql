DELETE FROM cdm_crm.member_structure_duration_member_frequency;


INSERT INTO cdm_crm.member_structure_duration_member_frequency (
    computing_until_month,
    computing_duration,
    member_no,
    frequency
)
    WITH
        --会员、下单日期的分组
        member_order_date AS (
            SELECT
            computing_until_month,
            computing_duration,
            member_no,
            DATE_FORMAT(order_deal_time, '%Y-%m-%d') AS order_deal_date
            FROM member_structure_duration_order_store
            GROUP BY computing_until_month, computing_duration, member_no, DATE_FORMAT(order_deal_time, '%Y-%m-%d')
            ORDER BY computing_until_month, computing_duration, member_no DESC
        ),
        --指定时间段内会员的购买次数（一天消费多次只算一次）
        duration_member_frequency AS (
            SELECT
            computing_until_month,
            computing_duration,
            member_no,
            COUNT(member_no) AS frequency
            FROM member_order_date
            GROUP BY computing_until_month, computing_duration, member_no
        )
    SELECT *
    FROM duration_member_frequency;
