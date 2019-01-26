INSERT INTO cdm_crm.member_structure_asset (
    computing_until_month,
    computing_duration,
    channel_type,
    sales_area,
    store_region,
    purchase_type,
    vip_type,
    reg_source,
    grade_code,
    member_type,
    recency,
    total_order_fact_amount,
    total_order_count,
    total_member_count,
    create_time
    )
    -- 会员购买渠道、购买所属销售区域、行政区域、等级、最近购买时间间隔、购买次数（一天消费多次只算一次）、累计消费金额、订单数
    -----------1, 12月时间段------------------------------------------------------------------------------------------------
    WITH
        --全渠道、全国区域下各等级下的新老会员下的recency统计
        grade_new_old_member_recency AS (
            SELECT
            computing_until_month,
            computing_duration,
            NULL                      AS channel_type,
            NULL                      AS sales_area,
            NULL                      AS store_region,
            'PURCHASED'               AS purchase_type,
            'VIP'                     AS vip_type,
            NULL                      AS reg_source,
            grade_code,
            member_type,
            recency,
            SUM(order_fact_amount)    AS total_order_fact_amount,
            COUNT(order_id)           AS total_order_count,
            COUNT(DISTINCT member_no) AS total_member_count,
            LOCALTIMESTAMP            AS create_time
            FROM member_structure_duration_order_store_last_grade_first_order_deal_time_recency_frequency
            WHERE CAST(member_no AS INTEGER) > 0
            GROUP BY computing_until_month, computing_duration, grade_code, member_type, recency
        ),
        --全渠道、全国区域下各等级下的新老会员统计
        grade_new_old_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            NULL                         AS channel_type,
            NULL                         AS sales_area,
            NULL                         AS store_region,
            'PURCHASED'                  AS purchase_type,
            'VIP'                        AS vip_type,
            NULL                         AS reg_source,
            grade_code,
            member_type,
            NULL                         AS recency,
            SUM(total_order_fact_amount) AS total_order_fact_amount,
            SUM(total_order_count)       AS total_order_count,
            SUM(total_member_count)      AS total_member_count,
            LOCALTIMESTAMP               AS create_time
            FROM grade_new_old_member_recency
            GROUP BY computing_until_month, computing_duration, grade_code, member_type
        ),
        --全渠道、全国区域下各等级的会员统计
        grade_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            NULL                         AS channel_type,
            NULL                         AS sales_area,
            NULL                         AS store_region,
            'PURCHASED'                  AS purchase_type,
            'VIP'                        AS vip_type,
            NULL                         AS reg_source,
            grade_code,
            NULL                         AS member_type,
            NULL                         AS recency,
            SUM(total_order_fact_amount) AS total_order_fact_amount,
            SUM(total_order_count)       AS total_order_count,
            SUM(total_member_count)      AS total_member_count,
            LOCALTIMESTAMP               AS create_time
            FROM grade_new_old_member
            GROUP BY computing_until_month, computing_duration, grade_code
        ),
        --全渠道、全国区域会员
        total_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            NULL                         AS channel_type,
            NULL                         AS sales_area,
            NULL                         AS store_region,
            'PURCHASED'                  AS purchase_type,
            'VIP'                        AS vip_type,
            NULL                         AS reg_source,
            NULL                         AS grade_code,
            NULL                         AS member_type,
            NULL                         AS recency,
            SUM(total_order_fact_amount) AS total_order_fact_amount,
            SUM(total_order_count)       AS total_order_count,
            SUM(total_member_count)      AS total_member_count,
            LOCALTIMESTAMP               AS create_time
            FROM grade_member
            --duration_order_store
            --   ods_crm.order_info oi, ods_crm.store_info si
            -- WHERE oi.store_code = si.store_code
            --       AND oi.order_deal_time IS NOT NULL
            --       AND oi.order_deal_time BETWEEN date_trunc('month',
            --                                                 DATE('{c_date}') + INTERVAL '-{computing_duration}' MONTH) AND date_trunc(
            --     'month', DATE('{c_date}'))
            GROUP BY computing_until_month, computing_duration
        ),
        --非会员
        not_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            NULL                   AS channel_type,
            NULL                   AS sales_area,
            NULL                   AS store_region,
            'PURCHASED'            AS purchase_type,
            'NOT_VIP'              AS vip_type,
            NULL                   AS reg_source,
            NULL                   AS grade_code,
            NULL                   AS member_type,
            NULL                   AS recency,
            SUM(order_fact_amount) AS total_order_fact_amount,
            COUNT(order_id)        AS total_order_count,
            0                      AS total_member_count,
            LOCALTIMESTAMP         AS create_time
            FROM member_structure_duration_order_store_last_grade_first_order_deal_time_recency_frequency
            WHERE CAST(member_no AS INTEGER) <= 0
            GROUP BY computing_until_month, computing_duration
        ),
        --有消费
        purchased_member AS (
            SELECT
            total_member.computing_until_month,
            total_member.computing_duration,
            NULL                                                                                 AS channel_type,
            NULL                                                                                 AS sales_area,
            NULL                                                                                 AS store_region,
            'PURCHASED'                                                                          AS purchase_type,
            NULL                                                                                 AS vip_type,
            NULL                                                                                 AS reg_source,
            NULL                                                                                 AS grade_code,
            NULL                                                                                 AS member_type,
            NULL                                                                                 AS recency,
            total_member.total_order_fact_amount + (CASE WHEN not_member.total_order_fact_amount IS NULL
                THEN 0
                                                    ELSE not_member.total_order_fact_amount END) AS total_order_fact_amount,
            total_member.total_order_count + (CASE WHEN not_member.total_order_count IS NULL
                THEN 0
                                                ELSE not_member.total_order_count END)             AS total_order_count,
            total_member.total_member_count + (CASE WHEN not_member.total_member_count IS NULL
                THEN 0
                                                ELSE not_member.total_member_count END)           AS total_member_count,
            LOCALTIMESTAMP                                                                       AS create_time
            FROM total_member
            LEFT JOIN not_member ON total_member.computing_until_month = not_member.computing_until_month AND
                                    total_member.computing_duration = not_member.computing_duration
        ),
        --潜在客户-注册来源
        potential_member_reg_source AS (
            SELECT
            computing_until_month,
            computing_duration,
            NULL                         AS channel_type,
            NULL                      AS sales_area,
            NULL                      AS store_region,
            'POTENTIAL'               AS purchase_type,
            NULL                      AS vip_type,
            reg_source,
            NULL                      AS grade_code,
            NULL                      AS member_type,
            NULL                      AS recency,
            NULL                      AS total_order_fact_amount,
            NULL                      AS total_order_count,
            COUNT(DISTINCT member_no) AS total_member_count,
            LOCALTIMESTAMP            AS create_time
            FROM member_structure_asset_duration_potential_reg_source
            GROUP BY computing_until_month, computing_duration, reg_source
        ),
        --潜在客户
        potential_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            NULL                    AS channel_type,
            NULL                    AS sales_area,
            NULL                    AS store_region,
            'POTENTIAL'             AS purchase_type,
            NULL                    AS vip_type,
            NULL                    AS reg_source,
            NULL                    AS grade_code,
            NULL                    AS member_type,
            NULL                    AS recency,
            NULL                    AS total_order_fact_amount,
            NULL                    AS total_order_count,
            SUM(total_member_count) AS total_member_count,
            LOCALTIMESTAMP          AS create_time
            FROM potential_member_reg_source
            GROUP BY computing_until_month, computing_duration
        ),

        --全渠道、全国区域会员
        total_member_asset AS (
            SELECT
            purchased_member.computing_until_month,
            purchased_member.computing_duration,
            NULL                                                                                 AS channel_type,
            NULL                                                                                 AS sales_area,
            NULL                                                                                 AS store_region,
            NULL                                                                                 AS purchase_type,
            NULL                                                                                 AS vip_type,
            NULL                                                                                 AS reg_source,
            NULL                                                                                 AS grade_code,
            NULL                                                                                 AS member_type,
            NULL                                                                                 AS recency,
            purchased_member.total_order_fact_amount                                             AS total_order_fact_amount,
            NULL                                                                                 AS total_order_count,
            purchased_member.total_member_count + (CASE WHEN potential_member.total_member_count IS NULL
                THEN 0
                                                    ELSE potential_member.total_member_count END) AS total_member_count,
            LOCALTIMESTAMP                                                                       AS create_time
            FROM purchased_member
            LEFT JOIN potential_member
                ON purchased_member.computing_until_month = potential_member.computing_until_month AND
                purchased_member.computing_duration = potential_member.computing_duration
        )
    SELECT *
    FROM total_member_asset
    UNION ALL
    SELECT *
    FROM potential_member
    UNION ALL
    SELECT *
    FROM potential_member_reg_source
    UNION ALL
    SELECT *
    FROM purchased_member
    UNION ALL
    SELECT *
    FROM not_member
    UNION ALL
    SELECT *
    FROM total_member
    UNION ALL
    SELECT *
    FROM grade_member
    UNION ALL
    SELECT *
    FROM grade_new_old_member
    UNION ALL
    SELECT *
    FROM grade_new_old_member_recency;