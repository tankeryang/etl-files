DELETE FROM ads_crm.rfm_base;


INSERT INTO ads_crm.rfm_base (
    horizon_type,
    vertical_type,
    horizon_type_range,
    vertical_type_range,
    horizon_expression,
    vertical_expression,
    computing_duration,
    computing_until_month,
    member_count,
    member_percentage,
    order_count,
    member_spent,
    monetary_per_order,
    order_count_per_member,
    monetary_per_member,
    create_time,
    vchr_computing_until_month
    )
    WITH
        --1、2年范围的总人数
        duration_member_count_temp AS (
            SELECT
            computing_duration,
            member_count,
            computing_until_month
            FROM cdm_crm.rfm_base
            WHERE rfm_conf_dimension_first = 0 AND rfm_conf_dimension_second = 0
        ),
        --------------------------------------------------------------------------------------------------
        --r, f, m
        --横维度合计， 横维度：R 纵维度：0 的客户数、客户占比、累计金、客单价
        r AS (
            SELECT
            horizon_type,
            vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            rfm_base_with_expr.computing_duration,
            rfm_base_with_expr.computing_until_month,
            rfm_base_with_expr.member_count,
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            rfm_base_with_expr.order_count,
            rfm_base_with_expr.member_spent,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 2))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time,
            rfm_base_with_expr.computing_until_month
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'R' AND
                rfm_base_with_expr.vertical_type IS NULL
        ),

        --f维度合计， 横维度：F 纵维度：0 的客户数、客户占比、累计金、客单价
        f AS (
            SELECT
            horizon_type,
            vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            rfm_base_with_expr.computing_duration,
            rfm_base_with_expr.computing_until_month,
            rfm_base_with_expr.member_count,
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            rfm_base_with_expr.order_count,
            rfm_base_with_expr.member_spent,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 2))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time,
            rfm_base_with_expr.computing_until_month
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'F' AND
                rfm_base_with_expr.vertical_type IS NULL
        ),

        --M维度合计， 横维度：M 纵维度：0 的客户数、客户占比、累计金、客单价
        m AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            rfm_base_with_expr.computing_duration,
            rfm_base_with_expr.computing_until_month,
            rfm_base_with_expr.member_count,
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 / duration_member_count_temp.member_count AS
                                DECIMAL(38, 4))), 0) AS member_percentage,
            rfm_base_with_expr.order_count,
            rfm_base_with_expr.member_spent,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.order_count AS DECIMAL(38, 2))),
                0)                                 AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                 AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                 AS monetary_per_member,
            LOCALTIMESTAMP                         AS create_time,
            rfm_base_with_expr.computing_until_month
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'M' AND rfm_base_with_expr.vertical_type IS NULL
        ),

        --G维度合计， 横维度：G 纵维度：0 的客户数、客户占比、累计金、客单价
        g AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            rfm_base_with_expr.computing_duration,
            rfm_base_with_expr.computing_until_month,
            rfm_base_with_expr.member_count,
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            rfm_base_with_expr.order_count,
            rfm_base_with_expr.member_spent,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 2))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time,
            rfm_base_with_expr.computing_until_month
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'G' AND
                rfm_base_with_expr.vertical_type IS NULL
        ),

        --总合计， 横维度：0 纵维度：0 的客户数、客户占比、累计金、客单价
        total AS (
            SELECT
            horizon_type,
            vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            rfm_base_with_expr.computing_duration,
            rfm_base_with_expr.computing_until_month,
            rfm_base_with_expr.member_count,
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            rfm_base_with_expr.order_count,
            rfm_base_with_expr.member_spent,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 2))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time,
            rfm_base_with_expr.computing_until_month
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type IS NULL AND
                rfm_base_with_expr.vertical_type IS NULL
        ),

        --------------------------------------------------------------------------------------------------
        --r_f, r_m, r_g, f_m, f_g, m_g
        --横维度：R 纵维度：F 交集的客户数、客户占比、累计金、客单价
        r_f AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            rfm_base_with_expr.computing_duration,
            rfm_base_with_expr.computing_until_month,
            rfm_base_with_expr.member_count,
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            rfm_base_with_expr.order_count,
            rfm_base_with_expr.member_spent,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 2))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time,
            rfm_base_with_expr.computing_until_month
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'R' AND
                rfm_base_with_expr.vertical_type = 'F'
        ),

        --横维度：R 纵维度：M 交集的客户数、客户占比、累计金、客单价
        r_m AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            rfm_base_with_expr.computing_duration,
            rfm_base_with_expr.computing_until_month,
            rfm_base_with_expr.member_count,
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 / duration_member_count_temp.member_count AS
                                DECIMAL(38, 4))), 0) AS member_percentage,
            rfm_base_with_expr.order_count,
            rfm_base_with_expr.member_spent,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.order_count AS DECIMAL(38, 2))),
                0)                                 AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                 AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                 AS monetary_per_member,
            LOCALTIMESTAMP                         AS create_time,
            rfm_base_with_expr.computing_until_month
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'R' AND rfm_base_with_expr.vertical_type = 'M'
        ),

        --横维度：R 纵维度：G 交集的客户数、客户占比、累计金、客单价
        r_g AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            rfm_base_with_expr.computing_duration,
            rfm_base_with_expr.computing_until_month,
            rfm_base_with_expr.member_count,
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            rfm_base_with_expr.order_count,
            rfm_base_with_expr.member_spent,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 2))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time,
            rfm_base_with_expr.computing_until_month
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'R' AND
                rfm_base_with_expr.vertical_type = 'G'
        ),


        --横维度：F 纵维度：M 交集的客户数、客户占比、累计金、客单价
        f_m AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            rfm_base_with_expr.computing_duration,
            rfm_base_with_expr.computing_until_month,
            rfm_base_with_expr.member_count,
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 / duration_member_count_temp.member_count AS
                                DECIMAL(38, 4))), 0) AS member_percentage,
            rfm_base_with_expr.order_count,
            rfm_base_with_expr.member_spent,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.order_count AS DECIMAL(38, 2))),
                0)                                 AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                 AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                 AS monetary_per_member,
            LOCALTIMESTAMP                         AS create_time,
            rfm_base_with_expr.computing_until_month
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'F' AND rfm_base_with_expr.vertical_type = 'M'
        ),

        --横维度合计， 横维度：R 纵维度：0 交集的客户数、客户占比、累计金、客单价
        f_g AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            rfm_base_with_expr.computing_duration,
            rfm_base_with_expr.computing_until_month,
            rfm_base_with_expr.member_count,
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            rfm_base_with_expr.order_count,
            rfm_base_with_expr.member_spent,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 2))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time,
            rfm_base_with_expr.computing_until_month
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'F' AND
                rfm_base_with_expr.vertical_type = 'G'
        ),
        --横维度合计， 横维度：R 纵维度：0 交集的客户数、客户占比、累计金、客单价
        m_g AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            rfm_base_with_expr.computing_duration,
            rfm_base_with_expr.computing_until_month,
            rfm_base_with_expr.member_count,
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            rfm_base_with_expr.order_count,
            rfm_base_with_expr.member_spent,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 2))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 2))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time,
            rfm_base_with_expr.computing_until_month
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'M' AND
                rfm_base_with_expr.vertical_type = 'G'
        )
    SELECT *
    FROM r
    UNION ALL
    SELECT *
    FROM f
    UNION ALL
    SELECT *
    FROM m
    UNION ALL
    SELECT *
    FROM g
    UNION ALL
    SELECT *
    FROM total
    UNION ALL
    SELECT *
    FROM r_f
    UNION ALL
    SELECT *
    FROM r_m
    UNION ALL
    SELECT *
    FROM r_g
    UNION ALL
    SELECT *
    FROM f_m
    UNION ALL
    SELECT *
    FROM f_g
    UNION ALL
    SELECT *
    FROM m_g;


INSERT INTO prod_mysql_crm_report_server.crm_mine.rfm_base (
    horizon_type,
    vertical_type,
    horizon_type_range,
    vertical_type_range,
    horizon_expression,
    vertical_expression,
    computing_duration,
    computing_until_month,
    member_count,
    member_percentage,
    order_count,
    member_spent,
    monetary_per_order,
    order_count_per_member,
    monetary_per_member,
    create_time
    )
    WITH
        --1、2年范围的总人数
        duration_member_count_temp AS (
            SELECT
            computing_duration,
            member_count,
            computing_until_month
            FROM cdm_crm.rfm_base
            WHERE rfm_conf_dimension_first = 0 AND rfm_conf_dimension_second = 0
        ),
        --------------------------------------------------------------------------------------------------
        --r, f, m
        --横维度合计， 横维度：R 纵维度：0 的客户数、客户占比、累计金、客单价
        r AS (
            SELECT
            horizon_type,
            vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            CAST(rfm_base_with_expr.computing_duration AS SMALLINT),
            rfm_base_with_expr.computing_until_month,
            CAST(rfm_base_with_expr.member_count AS INTEGER),
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            CAST(rfm_base_with_expr.order_count AS INTEGER),
            CAST(rfm_base_with_expr.member_spent AS DECIMAL(38, 4)),
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 4))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'R' AND
                rfm_base_with_expr.vertical_type IS NULL
        ),

        --f维度合计， 横维度：F 纵维度：0 的客户数、客户占比、累计金、客单价
        f AS (
            SELECT
            horizon_type,
            vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            CAST(rfm_base_with_expr.computing_duration AS SMALLINT),
            rfm_base_with_expr.computing_until_month,
            CAST(rfm_base_with_expr.member_count AS INTEGER),
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            CAST(rfm_base_with_expr.order_count AS INTEGER),
            CAST(rfm_base_with_expr.member_spent AS DECIMAL(38, 4)),
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 4))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'F' AND
                rfm_base_with_expr.vertical_type IS NULL
        ),

        --M维度合计， 横维度：M 纵维度：0 的客户数、客户占比、累计金、客单价
        m AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            CAST(rfm_base_with_expr.computing_duration AS SMALLINT),
            rfm_base_with_expr.computing_until_month,
            CAST(rfm_base_with_expr.member_count AS INTEGER),
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 / duration_member_count_temp.member_count AS
                                DECIMAL(38, 4))), 0) AS member_percentage,
            CAST(rfm_base_with_expr.order_count AS INTEGER),
            CAST(rfm_base_with_expr.member_spent AS DECIMAL(38, 4)),
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.order_count AS DECIMAL(38, 4))),
                0)                                 AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                 AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                 AS monetary_per_member,
            LOCALTIMESTAMP                         AS create_time
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'M' AND rfm_base_with_expr.vertical_type IS NULL
        ),

        --G维度合计， 横维度：G 纵维度：0 的客户数、客户占比、累计金、客单价
        g AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            CAST(rfm_base_with_expr.computing_duration AS SMALLINT),
            rfm_base_with_expr.computing_until_month,
            CAST(rfm_base_with_expr.member_count AS INTEGER),
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            CAST(rfm_base_with_expr.order_count AS INTEGER),
            CAST(rfm_base_with_expr.member_spent AS DECIMAL(38, 4)),
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 4))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'G' AND
                rfm_base_with_expr.vertical_type IS NULL
        ),

        --总合计， 横维度：0 纵维度：0 的客户数、客户占比、累计金、客单价
        total AS (
            SELECT
            horizon_type,
            vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            CAST(rfm_base_with_expr.computing_duration AS SMALLINT),
            rfm_base_with_expr.computing_until_month,
            CAST(rfm_base_with_expr.member_count AS INTEGER),
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            CAST(rfm_base_with_expr.order_count AS INTEGER),
            CAST(rfm_base_with_expr.member_spent AS DECIMAL(38, 4)),
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 4))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type IS NULL AND
                rfm_base_with_expr.vertical_type IS NULL
        ),

        --------------------------------------------------------------------------------------------------
        --r_f, r_m, r_g, f_m, f_g, m_g
        --横维度：R 纵维度：F 交集的客户数、客户占比、累计金、客单价
        r_f AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            CAST(rfm_base_with_expr.computing_duration AS SMALLINT),
            rfm_base_with_expr.computing_until_month,
            CAST(rfm_base_with_expr.member_count AS INTEGER),
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            CAST(rfm_base_with_expr.order_count AS INTEGER),
            CAST(rfm_base_with_expr.member_spent AS DECIMAL(38, 4)),
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 4))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'R' AND
                rfm_base_with_expr.vertical_type = 'F'
        ),

        --横维度：R 纵维度：M 交集的客户数、客户占比、累计金、客单价
        r_m AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            CAST(rfm_base_with_expr.computing_duration AS SMALLINT),
            rfm_base_with_expr.computing_until_month,
            CAST(rfm_base_with_expr.member_count AS INTEGER),
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 / duration_member_count_temp.member_count AS
                                DECIMAL(38, 4))), 0) AS member_percentage,
            CAST(rfm_base_with_expr.order_count AS INTEGER),
            CAST(rfm_base_with_expr.member_spent AS DECIMAL(38, 4)),
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.order_count AS DECIMAL(38, 4))),
                0)                                 AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                 AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                 AS monetary_per_member,
            LOCALTIMESTAMP                         AS create_time
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'R' AND rfm_base_with_expr.vertical_type = 'M'
        ),

        --横维度：R 纵维度：G 交集的客户数、客户占比、累计金、客单价
        r_g AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            CAST(rfm_base_with_expr.computing_duration AS SMALLINT),
            rfm_base_with_expr.computing_until_month,
            CAST(rfm_base_with_expr.member_count AS INTEGER),
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            CAST(rfm_base_with_expr.order_count AS INTEGER),
            CAST(rfm_base_with_expr.member_spent AS DECIMAL(38, 4)),
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 4))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'R' AND
                rfm_base_with_expr.vertical_type = 'G'
        ),


        --横维度：F 纵维度：M 交集的客户数、客户占比、累计金、客单价
        f_m AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            CAST(rfm_base_with_expr.computing_duration AS SMALLINT),
            rfm_base_with_expr.computing_until_month,
            CAST(rfm_base_with_expr.member_count AS INTEGER),
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 / duration_member_count_temp.member_count AS
                                DECIMAL(38, 4))), 0) AS member_percentage,
            CAST(rfm_base_with_expr.order_count AS INTEGER),
            CAST(rfm_base_with_expr.member_spent AS DECIMAL(38, 4)),
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.order_count AS DECIMAL(38, 4))),
                0)                                 AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                 AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                 AS monetary_per_member,
            LOCALTIMESTAMP                         AS create_time
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'F' AND rfm_base_with_expr.vertical_type = 'M'
        ),

        --横维度合计， 横维度：R 纵维度：0 交集的客户数、客户占比、累计金、客单价
        f_g AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            CAST(rfm_base_with_expr.computing_duration AS SMALLINT),
            rfm_base_with_expr.computing_until_month,
            CAST(rfm_base_with_expr.member_count AS INTEGER),
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            CAST(rfm_base_with_expr.order_count AS INTEGER),
            CAST(rfm_base_with_expr.member_spent AS DECIMAL(38, 4)),
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 4))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'F' AND
                rfm_base_with_expr.vertical_type = 'G'
        ),
        --横维度合计， 横维度：R 纵维度：0 交集的客户数、客户占比、累计金、客单价
        m_g AS (
            SELECT
            rfm_base_with_expr.horizon_type,
            rfm_base_with_expr.vertical_type,
            horizon_type_range,
            vertical_type_range,
            rfm_base_with_expr.horizon_expression,
            rfm_base_with_expr.vertical_expression,
            CAST(rfm_base_with_expr.computing_duration AS SMALLINT),
            rfm_base_with_expr.computing_until_month,
            CAST(rfm_base_with_expr.member_count AS INTEGER),
            --t4.member_count AS total_member_count,
            COALESCE(TRY(CAST(rfm_base_with_expr.member_count * 1.00 /
                                duration_member_count_temp.member_count AS DECIMAL(38, 4))), 0) AS member_percentage,
            CAST(rfm_base_with_expr.order_count AS INTEGER),
            CAST(rfm_base_with_expr.member_spent AS DECIMAL(38, 4)),
            COALESCE(TRY(CAST(rfm_base_with_expr.member_spent * 1.00 /
                                rfm_base_with_expr.order_count AS DECIMAL(38, 4))), 0)          AS monetary_per_order,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.order_count * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS order_count_per_member,
            COALESCE(
                TRY(CAST(rfm_base_with_expr.member_spent * 1.00 / rfm_base_with_expr.member_count AS DECIMAL(38, 4))),
                0)                                                                            AS monetary_per_member,
            LOCALTIMESTAMP                                                                    AS create_time
            FROM cdm_crm.rfm_base_with_expression rfm_base_with_expr, duration_member_count_temp
            WHERE rfm_base_with_expr.computing_duration = duration_member_count_temp.computing_duration
                AND rfm_base_with_expr.computing_until_month = duration_member_count_temp.computing_until_month
                AND rfm_base_with_expr.horizon_type = 'M' AND
                rfm_base_with_expr.vertical_type = 'G'
        )
    SELECT *
    FROM r
    UNION ALL
    SELECT *
    FROM f
    UNION ALL
    SELECT *
    FROM m
    UNION ALL
    SELECT *
    FROM g
    UNION ALL
    SELECT *
    FROM total
    UNION ALL
    SELECT *
    FROM r_f
    UNION ALL
    SELECT *
    FROM r_m
    UNION ALL
    SELECT *
    FROM r_g
    UNION ALL
    SELECT *
    FROM f_m
    UNION ALL
    SELECT *
    FROM f_g
    UNION ALL
    SELECT *
    FROM m_g;
