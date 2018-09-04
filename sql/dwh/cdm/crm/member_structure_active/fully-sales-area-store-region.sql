INSERT INTO cdm_crm.member_structure_active (
    computing_until_month,
    computing_duration,
    channel_type,
    sales_area,
    store_region,
    member_type,
    frequency_type,
    recency_type,
    total_member_count,
    total_order_fact_amount,
    monetary_per_member,
    total_repurchased_member_count,
    total_repurchased_order_fact_amount,
    total_repurchased_percentage,
    create_time
    )
    -- 会员购买渠道、购买所属销售区域、行政区域、新老客户、购买次数（一天消费多次只算一次）、上（或上上、上上上）月、季度、半年等之前等最近购买时间分布区间，客户数、成交额、人均成交额、重复购买人数、重复购买金额、重复购买率
    -----------1, 3, 6, 12个月时间段------------------------------------------------------------------------------------------------
    WITH
        --活跃新老客户购买次数
        active_member_type_frequency_member AS (
            SELECT
            *,
            CASE WHEN frequency > 1
                THEN 'MORE'
            ELSE 'ONE' END AS frequency_type
            FROM member_structure_duration_order_store_last_grade_first_order_deal_time_recency_frequency
        ),
        --***活跃新老客户-购买次数分组统计，客户数、成交额、人均成交额
        total_active_member_type_frequency_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            NULL                      AS channel_type,
            sales_area,
            store_region,
            member_type,
            frequency_type,
            NULL                      AS recency_type,
            COUNT(DISTINCT member_no) AS total_member_count,
            sum(order_fact_amount)    AS total_order_fact_amount,
            COALESCE(TRY(CAST(sum(order_fact_amount) * 1.00 / COUNT(DISTINCT member_no) AS DECIMAL(38, 2))),
                    0)               AS monetary_per_member,
            NULL                      AS total_repurchased_member_count,
            NULL                      AS total_repurchased_order_fact_amount,
            NULL                      AS total_repurchased_percentage,
            LOCALTIMESTAMP            AS create_time
            FROM active_member_type_frequency_member
            GROUP BY computing_until_month, computing_duration, sales_area, store_region, member_type, frequency_type
        ),
        ----活跃新老客户分组统计，总客户数、总成交额、总人均成交额
        total_active_member_type_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            sales_area,
            store_region,
            member_type,
            sum(total_member_count)      AS total_member_count,
            sum(total_order_fact_amount) AS total_order_fact_amount,
            COALESCE(TRY(CAST(sum(total_order_fact_amount) * 1.00 / sum(total_member_count) AS DECIMAL(38, 2))),
                    0)                  AS monetary_per_member
            FROM total_active_member_type_frequency_member
            GROUP BY computing_until_month, computing_duration, sales_area, store_region, member_type
        ),
        --活跃重复购买新老客户
        active_repurchased_member_type_member AS (
            SELECT *
            FROM active_member_type_frequency_member
            WHERE frequency > 1
        ),
        --重复购买新老客户分组统计，重复购买人数、重复购买金额
        total_repurchased_member_type_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            sales_area,
            store_region,
            member_type,
            COUNT(DISTINCT member_no) AS total_repurchased_member_count,
            sum(order_fact_amount)    AS total_repurchased_order_fact_amount
            FROM active_repurchased_member_type_member
            GROUP BY computing_until_month, computing_duration, sales_area, store_region, member_type
        ),
        --***活跃-重复购买-新老客户统计，总客户数、总成交额、人均成交额、重复购买人数、重复购买金额、重复购买率
        total_active_n_repurchased_member_type_member AS (
            SELECT
            tamtm.computing_until_month,
            tamtm.computing_duration,
            NULL           AS channel_type,
            tamtm.sales_area,
            tamtm.store_region,
            tamtm.member_type,
            NULL           AS frequency_type,
            NULL           AS recency_type,
            total_member_count,
            total_order_fact_amount,
            monetary_per_member,
            total_repurchased_member_count,
            total_repurchased_order_fact_amount,
            COALESCE(TRY(CAST(total_repurchased_member_count * 1.00 / total_member_count AS DECIMAL(38, 4))),
                    0)    AS total_repurchased_percentage,
            LOCALTIMESTAMP AS create_time
            FROM total_active_member_type_member tamtm, total_repurchased_member_type_member trmtm
            WHERE tamtm.computing_until_month = trmtm.computing_until_month AND
                tamtm.computing_duration = trmtm.computing_duration AND
                tamtm.sales_area = trmtm.sales_area AND
                tamtm.store_region = trmtm.store_region AND
                tamtm.member_type = trmtm.member_type
            ORDER BY tamtm.computing_until_month, tamtm.computing_duration, tamtm.sales_area, tamtm.store_region
        ),
        --***活跃-重复购买统计，总客户数、总成交额、总人均成交额、总重复购买人数、总重复购买金额、总重复购买率
        total_active_n_repurchased_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            NULL                                     AS channel_type,
            sales_area,
            store_region,
            NULL                                     AS member_type,
            NULL                                     AS frequency_type,
            NULL                                     AS recency_type,
            sum(total_member_count)                  AS total_member_count,
            sum(total_order_fact_amount)             AS total_order_fact_amount,
            COALESCE(TRY(CAST(sum(total_order_fact_amount) * 1.00 / sum(total_member_count) AS DECIMAL(38, 2))),
                    0)                              AS monetary_per_member,
            sum(total_repurchased_member_count)      AS total_repurchased_member_count,
            sum(total_repurchased_order_fact_amount) AS total_repurchased_order_fact_amount,
            COALESCE(TRY(CAST(sum(total_repurchased_member_count) * 1.00 / sum(total_member_count) AS DECIMAL(38, 4))),
                    0)                              AS total_repurchased_percentage,
            LOCALTIMESTAMP                           AS create_time
            FROM total_active_n_repurchased_member_type_member
            GROUP BY computing_until_month, computing_duration, sales_area, store_region
        ),
        --活跃老客户本月、季度、半年、年等的成交额
        member_structure_active_old_duration_monetary_per_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            sales_area,
            store_region,
            member_no,
            sum(order_fact_amount) AS total_order_fact_amount
            FROM member_structure_duration_order_store_last_grade_first_order_deal_time_recency_frequency
            WHERE member_type = 'OLD'
            GROUP BY computing_until_month, computing_duration, sales_area, store_region, member_no
        ),
        --活跃老客户本月、季度、半年、年等之前的最近一次购买分布在上(及上上、上上上、...等)月、季度、半年、年等的哪个区间统计，客户数、成交额、人均成交额
        member_structure_active_old_recency_type_monetary_per_member AS (
            SELECT
            old.computing_until_month,
            old.computing_duration,
            old.sales_area,
            old.store_region,
            old.member_no,
            old.total_order_fact_amount,
            CASE WHEN bdmo.max_order_deal_time BETWEEN ald.last_computing_duration_time_start AND ald.last_computing_duration_time_end
                THEN 'last'
            WHEN bdmo.max_order_deal_time BETWEEN ald.double_last_computing_duration_time_start AND ald.double_last_computing_duration_time_end
                THEN 'double_last'
            WHEN bdmo.max_order_deal_time BETWEEN ald.triple_last_computing_duration_time_start AND ald.triple_last_computing_duration_time_end
                THEN 'triple_last'
            ELSE 'more_last' END AS recency_type
            FROM member_structure_active_old_duration_monetary_per_member old,
            member_structure_before_duration_max_order bdmo,
            member_structure_active_last_duration ald
            WHERE old.computing_until_month = bdmo.computing_until_month
                AND old.computing_duration = bdmo.computing_duration
                AND bdmo.channel_type IS NULL
                AND old.sales_area = old.sales_area
                AND old.store_region = bdmo.store_region
                AND old.member_no = bdmo.member_no
                AND old.computing_until_month = ald.computing_until_month
                AND old.computing_duration = ald.computing_duration
        ),
        --***活跃老客户本月、季度、半年、年等之前的最近一次购买分布在上(及上上、上上上、...等)月、季度、半年、年等的哪个区间
        total_active_old_recency_type_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            NULL                         AS channel_type,
            sales_area,
            store_region,
            'OLD'                        AS member_type,
            NULL                         AS frequency_type,
            recency_type,
            COUNT(member_no)             AS total_member_count,
            sum(total_order_fact_amount) AS total_order_fact_amount,
            COALESCE(TRY(CAST(sum(total_order_fact_amount) * 1.00 / COUNT(member_no) AS DECIMAL(38, 2))),
                    0)                  AS monetary_per_member,
            NULL                         AS total_repurchased_member_count,
            NULL                         AS total_repurchased_order_fact_amount,
            NULL                         AS total_repurchased_percentage,
            LOCALTIMESTAMP               AS create_time
            FROM member_structure_active_old_recency_type_monetary_per_member
            GROUP BY computing_until_month, computing_duration, sales_area, store_region, recency_type
        )

    SELECT *
    FROM total_active_member_type_frequency_member
    UNION ALL
    SELECT *
    FROM total_active_n_repurchased_member_type_member
    UNION ALL
    SELECT *
    FROM total_active_n_repurchased_member
    UNION ALL
    SELECT *
    FROM total_active_old_recency_type_member;