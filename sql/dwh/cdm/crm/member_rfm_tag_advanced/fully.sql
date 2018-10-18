INSERT INTO cdm_crm.member_rfm_tag_advanced (
    computing_until_date,
    computing_duration,
    member_no,
    average_order_amount,
    average_purchase_interval,
    total_purchase_frequency,
    total_order_fact_amount,
    total_order_count,
    totaL_order_item_quantity,
    total_return_frequency,
    total_return_amount,
    create_time
)
--会员平均购买时间、金额、间隙，累计购买次数、金额、订单数、件数，退款次数、金额
-----------30,60，90，180天时间段------------------------------------------------------------------------------------------------
    WITH
        --订单范围
        order_info_range AS (
            SELECT *
            FROM ods_crm.order_info
            WHERE cast(member_no AS INTEGER) > 0 AND order_deal_time IS NOT NULL AND
                order_deal_time >= (CURRENT_DATE + INTERVAL '-1' DAY +
                                        INTERVAL '-{computing_duration}' DAY) AND order_deal_time < CURRENT_DATE
        ),
        --0、正价单
        order_info AS (
            SELECT *
            FROM order_info_range
            WHERE order_fact_amount >= 0
        ),
        --负价单范围
        return_order_info AS (
            SELECT *
            FROM order_info_range
            WHERE order_fact_amount < 0
        ),
        --会员退货+新买商品的单
        member_purchase_from_return AS (
            SELECT DISTINCT roi.order_id
            FROM return_order_info roi, ods_crm.order_item oit
            WHERE roi.order_id = oit.order_id AND
                oit.quantity > 0
        ),
        --union all order_info, member_purchase_from_return
        union_all_order_info_n_member_purchase_from_return AS (
        SELECT *
        FROM order_info
        UNION ALL
        SELECT roi.*
        FROM return_order_info roi
        WHERE roi.order_id IN (SELECT order_id
                                FROM member_purchase_from_return)
        ),
        --会员、下单日期的分组
        member_order_date AS (
            SELECT
            member_no,
            date_format(order_deal_time, '%Y-%m-%d') AS order_deal_date
            FROM union_all_order_info_n_member_purchase_from_return
            GROUP BY member_no, date_format(order_deal_time, '%Y-%m-%d')
        ),
        --指定时间段内会员的购买次数（一天消费多次只算一次）
        member_frequency AS (
            SELECT
            member_no,
            COUNT(member_no) AS frequency
            FROM member_order_date
            GROUP BY member_no
        ),
        --累计购买金额、订单数、件数
        member_order_count_item_count AS (
            SELECT
            oi.member_no,
            min(oi.order_deal_time)     AS min_order_deal_time,
            max(oi.order_deal_time)     AS max_order_deal_time,
            count(DISTINCT oi.order_id) AS total_order_count,
            --         sum(order_item_quantity) AS total_order_item_quantity,
            sum(oit.quantity)             AS total_order_item_quantity
            FROM union_all_order_info_n_member_purchase_from_return oi, ods_crm.order_item oit
            WHERE oi.order_id = oit.order_id AND
                oit.quantity > 0
            GROUP BY oi.member_no
        ),
        --累计购买金额
        member_monetary_total AS (
            SELECT
            oi.member_no,
            sum(CASE WHEN oit.sub_coupon_amount IS NOT NULL
                THEN oit.sub_coupon_amount
                ELSE oit.fact_amount END) AS total_order_fact_amount
            FROM union_all_order_info_n_member_purchase_from_return oi, ods_crm.order_item oit
            WHERE oi.order_id = oit.order_id AND
                oit.quantity > 0
            GROUP BY oi.member_no
        ),
        --平均购买时间、金额、间隙
        average_purchase_time_monetary_interval AS (
            SELECT
            mocic.member_no,
            COALESCE(TRY(CAST(total_order_fact_amount * 1.00 / total_order_count AS DECIMAL(38, 2))),
                    0) AS average_order_amount,
            --           date_diff('day', DATE(max(min_order_deal_time)), date(max_order_deal_time)) as days,
            COALESCE(TRY(CAST(date_diff('day', DATE(min_order_deal_time), date(max_order_deal_time)) * 1.00 /
                                total_order_count AS DECIMAL(38, 2))),
                    0) AS average_purchase_interval
            FROM member_order_count_item_count mocic, member_monetary_total mmt
            WHERE mocic.member_no = mmt.member_no
        ),
        --退款次数、金额
        return_count_monetary AS (
            SELECT
            member_no,
            count(order_id)        AS total_return_count,
            sum(order_fact_amount) AS total_return_amount
            FROM return_order_info
            GROUP BY member_no
        )
    SELECT
        date_format(CURRENT_DATE + INTERVAL '-1' DAY, '%Y-%m-%d') AS computing_until_date,
        CAST('{computing_duration}' AS INTEGER)                   AS computing_duration,
        average.member_no,
        average.average_order_amount,
        average.average_purchase_interval,

        mf.frequency,
        total.total_order_fact_amount,
        count.total_order_count,
        count.total_order_item_quantity,

        rcm.total_return_count,
        abs(rcm.total_return_amount)                              AS total_return_amount,
        LOCALTIMESTAMP                                            AS create_time
    FROM average_purchase_time_monetary_interval average
        INNER JOIN member_order_count_item_count count
        ON average.member_no = count.member_no
        INNER JOIN member_monetary_total total
        ON average.member_no = total.member_no
        INNER JOIN member_frequency mf
        ON average.member_no = mf.member_no
        LEFT JOIN return_count_monetary rcm
        ON average.member_no = rcm.member_no;