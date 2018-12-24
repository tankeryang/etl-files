INSERT INTO cdm_crm.member_rfm (
    member_no,
    computing_duration,
    grade_code,
    recency,
    frequency,
    monetary_total,
    order_count,
    monetary_per_order,
    circle_first_repurchase,
    circle_average_repurchase,
    computing_until_month,
    create_time
    )
    --会员最近购买时间间隔、购买次数（一天消费多次只算一次）、累计消费金额、客单价、首次回购周期、平均回购周期
    -----------1,2年时间段------------------------------------------------------------------------------------------------
    WITH
        --订单范围
        order_info_range AS (
            SELECT *
            FROM ods_crm.order_info
            WHERE cast(member_no AS INTEGER) > 0 AND
                order_deal_time >= date_trunc('month',
                                                    CURRENT_DATE + INTERVAL '-{computing_duration}' YEAR) AND order_deal_time < date_trunc(
                    'month', CURRENT_DATE)
        ),
        --指定时间段内会员购买时间间隔、购买次数（一天消费多次只算一次）、订单数量(基于正价单、退换货(并买新商品)、累计金额、客单价、最小、最大下单时间，及下单日期的数组
        member_recency_frequency_order_count_min_max_order_deal_date_n_arr_monetary_total_n_per_order AS (
            SELECT
            oi.member_no,
            COUNT(DISTINCT oi.order_id)                                                     AS     order_count,
            min(oi.order_deal_time)                                                         AS     min_order_deal_date,
            max(oi.order_deal_time)                                                         AS     max_order_deal_date,
            date_diff('day', DATE(max(oi.order_deal_time)),
                        date_trunc('month', CURRENT_DATE) + INTERVAL '-1' DAY) recency,
            count(DISTINCT date_format(oi.order_deal_time, '%Y-%m-%d'))                     AS     frequency,
            sum(CASE WHEN oit.sub_coupon_amount IS NOT NULL
                THEN oit.sub_coupon_amount
                ELSE oit.fact_amount END)                                                   AS     monetary_total,
            ARRAY_SORT(ARRAY_DISTINCT(ARRAY_AGG(date_format(order_deal_time, '%Y-%m-%d')))) AS     order_deal_date
            FROM order_info_range oi, ods_crm.order_item oit
            WHERE oi.order_id = oit.order_id AND
                oit.quantity > 0
            GROUP BY member_no
        ),
        --指定时间段内会员的最新等级
        member_last_log AS (
            SELECT DISTINCT
            mgl.member_no,
            mgl.after_grade_id,
            mgi.grade_name,
            mgi.grade_code,
            mgl.grade_change_time
            FROM prod_mysql_crm.crm.member_grade_log mgl
            INNER JOIN order_info_range oi ON mgl.member_no = oi.member_no
            LEFT JOIN prod_mysql_crm.member_grade_info mgi ON mgl.after_grade_id = mgi.grade_id
            WHERE 1 > (SELECT count(*)
                    FROM prod_mysql_crm.crm.member_grade_log
                    WHERE member_no = mgl.member_no AND grade_change_time > mgl.grade_change_time)
                AND date_diff('day', mgl.grade_change_time, date_trunc('month', CURRENT_DATE)) > 0
            ORDER BY mgl.member_no, mgl.grade_change_time DESC
        )

    SELECT
        rfm.member_no,
        CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
        CASE WHEN mll.grade_code IS NULL
        THEN 'FIV_GENERAL_VIP'
        ELSE mll.grade_code END                                  AS grade_code,
        rfm.recency,
        rfm.frequency,
        rfm.monetary_total,
        rfm.order_count,
        COALESCE(TRY(CAST(rfm.monetary_total / rfm.order_count AS DECIMAL(38, 2))),
                0)                                              AS monetary_per_order,
        CASE WHEN rfm.frequency < 2
        THEN 0
        ELSE date_diff('day', date(rfm.order_deal_date [1]),
                    date(rfm.order_deal_date [2]))
        END                                                      AS circle_first_repurchase,
        CASE WHEN rfm.frequency < 2
        THEN 0
        ELSE cast(
            floor(COALESCE(TRY(CAST(date_diff('day', date(rfm.min_order_deal_date),
                                            date(rfm.max_order_deal_date)) * 1.00 /
                                    rfm.frequency AS
                                    DECIMAL(38, 2))), 0)) AS INTEGER)
        END                                                      AS circle_average_repurchase,
        date_format(CURRENT_DATE + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
        LOCALTIMESTAMP                                           AS create_time
    FROM member_recency_frequency_order_count_min_max_order_deal_date_n_arr_monetary_total_n_per_order rfm
        LEFT JOIN member_last_log mll
        ON rfm.member_no = mll.member_no;