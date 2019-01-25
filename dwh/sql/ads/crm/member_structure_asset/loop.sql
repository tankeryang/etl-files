INSERT INTO ads_crm.member_structure_asset (
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
    recency_type,
    total_member_count,
    member_count_percentage,
    total_order_fact_amount,
    order_fact_amount_percentage,
    total_order_count,
    create_time,
    vchr_computing_until_month
    )
    WITH
        --各渠道、区域下各等级下的新老会员下的recency统计
        grade_new_old_member_recency AS (
            SELECT
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
            sum(total_member_count)      AS total_member_count,
            sum(total_order_fact_amount) AS total_order_fact_amount,
            sum(total_order_count)       AS total_order_count
            FROM cdm_crm.member_structure_asset
            WHERE purchase_type = 'PURCHASED' AND vip_type = 'VIP' AND reg_source IS NULL AND
                grade_code IS NOT NULL AND member_type IS NOT NULL AND recency IS NOT NULL
            GROUP BY computing_until_month, computing_duration, channel_type, sales_area, store_region, purchase_type,
            vip_type, reg_source, grade_code, member_type, recency
        ),
        --各渠道、区域下各等级下的新老会员下的recency范围统计
        grade_new_old_member_recency_range AS (
            SELECT
            *,
            CASE WHEN recency >= 0 AND recency <= 30
                THEN 'R<=30'
            WHEN recency >= 30 AND recency <= 60
                THEN '30<R<=90'
            WHEN recency >= 60 AND recency <= 90
                THEN '90<R<=180'
            WHEN recency >= 90 AND recency <= 120
                THEN '180<R<=360'
            ELSE 'R>360' END AS recency_type
            FROM grade_new_old_member_recency
        ),
        --各渠道、区域下各等级下的新老会员下的recency统计
        grade_new_old_member_recency_type AS (
            SELECT
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
            recency_type,
            sum(total_member_count)      AS total_member_count,
            sum(total_order_fact_amount) AS total_order_fact_amount,
            sum(total_order_count)       AS total_order_count
            FROM grade_new_old_member_recency_range
            GROUP BY computing_until_month, computing_duration, channel_type, sales_area, store_region, purchase_type,
            vip_type, reg_source, grade_code, member_type, recency_type
        ),
        --各渠道、区域下各等级下的新老会员统计
        grade_new_old_member AS (
            SELECT
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
            NULL                         AS recency_type,
            sum(total_member_count)      AS total_member_count,
            sum(total_order_fact_amount) AS total_order_fact_amount,
            sum(total_order_count)       AS total_order_count
            FROM grade_new_old_member_recency
            GROUP BY computing_until_month, computing_duration, channel_type, sales_area, store_region, purchase_type,
            vip_type, reg_source, grade_code, member_type
        ),
        --各渠道、区域下各等级下的新老会员下的recency统计 + 会员、金额占比
        grade_new_old_member_recency_with_percentage AS (
            SELECT
            gnomr.computing_duration,
            gnomr.channel_type,
            gnomr.sales_area,
            gnomr.store_region,
            gnomr.purchase_type,
            gnomr.vip_type,
            gnomr.reg_source,
            gnomr.grade_code,
            gnomr.member_type,
            gnomr.recency_type,
            gnomr.total_member_count,
            COALESCE(TRY(CAST(gnomr.total_member_count * 1.00 /
                                gnom.total_member_count AS DECIMAL(38, 4))), 0)      AS member_count_percentage,
            gnomr.total_order_fact_amount,
            COALESCE(TRY(CAST(gnomr.total_order_fact_amount * 1.00 /
                                gnom.total_order_fact_amount AS DECIMAL(38, 4))), 0) AS order_fact_amount_percentage,
            gnomr.total_order_count,
            LOCALTIMESTAMP                                                         AS create_time,
            gnomr.computing_until_month                                            AS computing_until_month
            FROM grade_new_old_member_recency_type gnomr, grade_new_old_member gnom
            WHERE gnomr.computing_until_month = gnom.computing_until_month AND
                gnomr.computing_duration = gnom.computing_duration AND
                ((gnomr.channel_type IS NULL AND gnom.channel_type IS NULL) OR gnomr.channel_type = gnom.channel_type) AND
                ((gnomr.sales_area IS NULL AND gnom.sales_area IS NULL) OR gnomr.sales_area = gnom.sales_area) AND
                ((gnomr.store_region IS NULL AND gnom.store_region IS NULL) OR gnomr.store_region = gnom.store_region) AND
                ((gnomr.purchase_type IS NULL AND gnom.purchase_type IS NULL) OR gnomr.purchase_type = gnom.purchase_type)
                AND
                ((gnomr.vip_type IS NULL AND gnom.vip_type IS NULL) OR gnomr.vip_type = gnom.vip_type) AND
                ((gnomr.reg_source IS NULL AND gnom.reg_source IS NULL) OR gnomr.reg_source = gnom.reg_source) AND
                ((gnomr.grade_code IS NULL AND gnom.grade_code IS NULL) OR gnomr.grade_code = gnom.grade_code) AND
                ((gnomr.member_type IS NULL AND gnom.member_type IS NULL) OR gnomr.member_type = gnom.member_type)
        ),
        --各渠道、区域下各等级的会员统计
        grade_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            purchase_type,
            vip_type,
            reg_source,
            grade_code,
            NULL                         AS member_type,
            NULL                         AS recency_type,
            sum(total_member_count)      AS total_member_count,
            sum(total_order_fact_amount) AS total_order_fact_amount,
            sum(total_order_count)       AS total_order_count
            FROM grade_new_old_member
            GROUP BY computing_until_month, computing_duration, channel_type, sales_area, store_region, purchase_type,
            vip_type, reg_source, grade_code
        ),
        --各渠道、区域下各等级下的新老会员统计 + 会员、金额占比
        grade_new_old_member_with_percentage AS (
            SELECT
            gnom.computing_duration,
            gnom.channel_type,
            gnom.sales_area,
            gnom.store_region,
            gnom.purchase_type,
            gnom.vip_type,
            gnom.reg_source,
            gnom.grade_code,
            gnom.member_type,
            gnom.recency_type,
            gnom.total_member_count,
            COALESCE(TRY(CAST(gnom.total_member_count * 1.00 /
                                gm.total_member_count AS DECIMAL(38, 4))), 0)      AS member_count_percentage,
            gnom.total_order_fact_amount,
            COALESCE(TRY(CAST(gnom.total_order_fact_amount * 1.00 /
                                gm.total_order_fact_amount AS DECIMAL(38, 4))), 0) AS order_fact_amount_percentage,
            gnom.total_order_count,
            LOCALTIMESTAMP                                                       AS create_time,
            gnom.computing_until_month                                           AS computing_until_month
            FROM grade_new_old_member gnom, grade_member gm
            WHERE gnom.computing_until_month = gm.computing_until_month AND
                gnom.computing_duration = gm.computing_duration AND
                ((gnom.channel_type IS NULL AND gm.channel_type IS NULL) OR gnom.channel_type = gm.channel_type) AND
                ((gnom.sales_area IS NULL AND gm.sales_area IS NULL) OR gnom.sales_area = gm.sales_area) AND
                ((gnom.store_region IS NULL AND gm.store_region IS NULL) OR gnom.store_region = gm.store_region) AND
                ((gnom.purchase_type IS NULL AND gm.purchase_type IS NULL) OR gnom.purchase_type = gm.purchase_type) AND
                ((gnom.vip_type IS NULL AND gm.vip_type IS NULL) OR gnom.vip_type = gm.vip_type) AND
                ((gnom.reg_source IS NULL AND gm.reg_source IS NULL) OR gnom.reg_source = gm.reg_source) AND
                ((gnom.grade_code IS NULL AND gm.grade_code IS NULL) OR gnom.grade_code = gm.grade_code)
        ),
        --各渠道、区域下会员
        total_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            purchase_type,
            vip_type,
            reg_source,
            NULL                         AS grade_code,
            NULL                         AS member_type,
            NULL                         AS recency_type,
            sum(total_order_fact_amount) AS total_order_fact_amount,
            sum(total_order_count)       AS total_order_count,
            sum(total_member_count)      AS total_member_count,
            LOCALTIMESTAMP               AS create_time
            FROM grade_member
            GROUP BY computing_until_month, computing_duration, channel_type, sales_area, store_region, purchase_type,
            vip_type, reg_source
        ),
        --各渠道、区域下各等级的会员统计 + 会员、金额占比
        grade_member_with_percentage AS (
            SELECT
            gm.computing_duration,
            gm.channel_type,
            gm.sales_area,
            gm.store_region,
            gm.purchase_type,
            gm.vip_type,
            gm.reg_source,
            gm.grade_code,
            gm.member_type,
            gm.recency_type,
            gm.total_member_count,
            COALESCE(TRY(CAST(gm.total_member_count * 1.00 /
                                tm.total_member_count AS DECIMAL(38, 4))), 0)      AS member_count_percentage,
            gm.total_order_fact_amount,
            COALESCE(TRY(CAST(gm.total_order_fact_amount * 1.00 /
                                tm.total_order_fact_amount AS DECIMAL(38, 4))), 0) AS order_fact_amount_percentage,
            gm.total_order_count,
            LOCALTIMESTAMP                                                       AS create_time,
            gm.computing_until_month                                             AS computing_until_month
            FROM grade_member gm, total_member tm
            WHERE gm.computing_until_month = tm.computing_until_month AND
                gm.computing_duration = tm.computing_duration AND
                ((gm.channel_type IS NULL AND tm.channel_type IS NULL) OR gm.channel_type = tm.channel_type) AND
                ((gm.sales_area IS NULL AND tm.sales_area IS NULL) OR gm.sales_area = tm.sales_area) AND
                ((gm.store_region IS NULL AND tm.store_region IS NULL) OR gm.store_region = tm.store_region) AND
                ((gm.purchase_type IS NULL AND tm.purchase_type IS NULL) OR gm.purchase_type = tm.purchase_type) AND
                ((gm.vip_type IS NULL AND tm.vip_type IS NULL) OR gm.vip_type = tm.vip_type) AND
                ((gm.reg_source IS NULL AND tm.reg_source IS NULL) OR gm.reg_source = tm.reg_source)
        ),
        --各渠道、区域下非会员
        not_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            'PURCHASED'                  AS purchase_type,
            'NOT_VIP'                    AS vip_type,
            NULL                         AS reg_source,
            NULL                         AS grade_code,
            NULL                         AS member_type,
            NULL                         AS recency_type,
            sum(total_order_fact_amount) AS total_order_fact_amount,
            sum(total_order_count)       AS total_order_count,
            0                            AS total_member_count,
            LOCALTIMESTAMP               AS create_time
            FROM cdm_crm.member_structure_asset
            WHERE purchase_type = 'PURCHASED' AND vip_type = 'NOT_VIP'
            GROUP BY computing_until_month, computing_duration, channel_type, sales_area, store_region
        ),
        --各渠道、区域下有消费
        purchased_member AS (
            SELECT
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            'PURCHASED'                  AS purchase_type,
            NULL                         AS vip_type,
            NULL                         AS reg_source,
            NULL                         AS grade_code,
            NULL                         AS member_type,
            NULL                         AS recency_type,
            sum(total_member_count)      AS total_member_count,
            NULL                         AS member_count_percentage,
            sum(total_order_fact_amount) AS total_order_fact_amount,
            NULL                         AS order_fact_amount_percentage,
            sum(total_order_count)       AS total_order_count,
            LOCALTIMESTAMP               AS create_time,
            computing_until_month        AS computing_until_month
            FROM cdm_crm.member_structure_asset
            WHERE purchase_type = 'PURCHASED' AND vip_type IS NULL
            GROUP BY computing_until_month, computing_duration, channel_type, sales_area, store_region
        ),
        --各渠道、区域下非会员 + 会员、金额占比
        not_member_with_percentage AS (
            SELECT
            nm.computing_duration,
            nm.channel_type,
            nm.sales_area,
            nm.store_region,
            nm.purchase_type,
            nm.vip_type,
            nm.reg_source,
            nm.grade_code,
            nm.member_type,
            nm.recency_type,
            nm.total_member_count,
            COALESCE(TRY(CAST(nm.total_member_count * 1.00 /
                                pm.total_member_count AS DECIMAL(38, 4))), 0)      AS member_count_percentage,
            nm.total_order_fact_amount,
            COALESCE(TRY(CAST(nm.total_order_fact_amount * 1.00 /
                                pm.total_order_fact_amount AS DECIMAL(38, 4))), 0) AS order_fact_amount_percentage,
            nm.total_order_count,
            LOCALTIMESTAMP                                                       AS create_time,
            nm.computing_until_month                                             AS computing_until_month
            FROM not_member nm, purchased_member pm
            WHERE nm.computing_until_month = pm.computing_until_month AND
                nm.computing_duration = pm.computing_duration AND
                ((nm.channel_type IS NULL AND pm.channel_type IS NULL) OR nm.channel_type = pm.channel_type) AND
                ((nm.sales_area IS NULL AND pm.sales_area IS NULL) OR nm.sales_area = pm.sales_area) AND
                ((nm.store_region IS NULL AND pm.store_region IS NULL) OR nm.store_region = pm.store_region) AND
                nm.purchase_type = pm.purchase_type
        ),
        --各渠道、区域下会员 + 会员、金额占比
        total_member_with_percentage AS (
            SELECT
            tm.computing_duration,
            tm.channel_type,
            tm.sales_area,
            tm.store_region,
            tm.purchase_type,
            tm.vip_type,
            tm.reg_source,
            tm.grade_code,
            tm.member_type,
            tm.recency_type,
            tm.total_member_count,
            COALESCE(TRY(CAST(tm.total_member_count * 1.00 /
                                pm.total_member_count AS DECIMAL(38, 4))), 0)      AS member_count_percentage,
            tm.total_order_fact_amount,
            COALESCE(TRY(CAST(tm.total_order_fact_amount * 1.00 /
                                pm.total_order_fact_amount AS DECIMAL(38, 4))), 0) AS order_fact_amount_percentage,
            tm.total_order_count,
            LOCALTIMESTAMP                                                       AS create_time,
            tm.computing_until_month                                             AS computing_until_month
            FROM total_member tm, purchased_member pm
            WHERE tm.computing_until_month = pm.computing_until_month AND
                tm.computing_duration = pm.computing_duration AND
                ((tm.channel_type IS NULL AND pm.channel_type IS NULL) OR tm.channel_type = pm.channel_type) AND
                ((tm.sales_area IS NULL AND pm.sales_area IS NULL) OR tm.sales_area = pm.sales_area) AND
                ((tm.store_region IS NULL AND pm.store_region IS NULL) OR tm.store_region = pm.store_region) AND
                tm.purchase_type = pm.purchase_type
        ),

        --各渠道、区域下潜在客户-注册来源(包括总合计的记录)
        potential_member_reg_source AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            'POTENTIAL'             AS purchase_type,
            NULL                    AS vip_type,
            reg_source,
            NULL                    AS grade_code,
            NULL                    AS member_type,
            NULL                    AS recency_type,
            NULL                    AS total_order_fact_amount,
            NULL                    AS total_order_count,
            sum(total_member_count) AS total_member_count
            FROM cdm_crm.member_structure_asset
            WHERE purchase_type = 'POTENTIAL'
            GROUP BY computing_until_month, computing_duration, channel_type, sales_area, store_region, reg_source
        ),
        --各渠道、区域下潜在客户
        potential_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            'POTENTIAL'             AS purchase_type,
            NULL                    AS vip_type,
            NULL                    AS reg_source,
            NULL                    AS grade_code,
            NULL                    AS member_type,
            NULL                    AS recency_type,
            sum(total_member_count) AS total_member_count,
            NULL                    AS member_count_percentage,
            NULL                    AS total_order_fact_amount,
            NULL                    AS order_fact_amount_percentage,
            NULL                    AS total_order_count,
            LOCALTIMESTAMP          AS create_time
            FROM potential_member_reg_source
            WHERE purchase_type = 'POTENTIAL' AND reg_source IS NULL
            GROUP BY computing_until_month, computing_duration, channel_type, sales_area, store_region
        ),
        --各渠道、区域下潜在客户-注册来源
        potential_member_reg_source_with_percentage AS (
            SELECT
            pmrs.computing_duration,
            pmrs.channel_type,
            pmrs.sales_area,
            pmrs.store_region,
            pmrs.purchase_type,
            pmrs.vip_type,
            pmrs.reg_source,
            pmrs.grade_code,
            pmrs.member_type,
            pmrs.recency_type,
            pmrs.total_member_count,
            COALESCE(TRY(CAST(pmrs.total_member_count * 1.00 /
                                pm.total_member_count AS DECIMAL(38, 4))), 0) AS member_count_percentage,
            pmrs.total_order_fact_amount,
            NULL                                                            AS order_fact_amount_percentage,
            pmrs.total_order_count,
            LOCALTIMESTAMP                                                  AS create_time,
            pmrs.computing_until_month                                      AS computing_until_month
            FROM potential_member_reg_source pmrs, potential_member pm
            WHERE pmrs.computing_until_month = pm.computing_until_month AND
                pmrs.computing_duration = pm.computing_duration AND
                ((pmrs.channel_type IS NULL AND pm.channel_type IS NULL) OR pmrs.channel_type = pm.channel_type) AND
                ((pmrs.sales_area IS NULL AND pm.sales_area IS NULL) OR pmrs.sales_area = pm.sales_area) AND
                ((pmrs.store_region IS NULL AND pm.store_region IS NULL) OR pmrs.store_region = pm.store_region) AND
                ((pmrs.purchase_type IS NULL AND pm.purchase_type IS NULL) OR pmrs.purchase_type = pm.purchase_type)

        ),
        --各渠道、区域下总会员资产
        total_member_asset AS (
            SELECT
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            NULL                         AS purchase_type,
            NULL                         AS vip_type,
            NULL                         AS reg_source,
            NULL                         AS grade_code,
            NULL                         AS member_type,
            NULL                         AS recency_type,
            sum(total_member_count)      AS total_member_count,
            NULL                         AS member_count_percentage,
            sum(total_order_fact_amount) AS total_order_fact_amount,
            NULL                         AS order_fact_amount_percentage,
            sum(total_order_count)       AS total_order_count,
            LOCALTIMESTAMP               AS create_time,
            computing_until_month        AS computing_until_month
            FROM cdm_crm.member_structure_asset
            WHERE purchase_type IS NULL
            GROUP BY computing_until_month, computing_duration, channel_type, sales_area, store_region
        )
    SELECT *
    FROM total_member_asset
    UNION ALL
    SELECT *
    FROM potential_member_reg_source_with_percentage
    UNION ALL
    SELECT *
    FROM purchased_member
    UNION ALL
    SELECT *
    FROM not_member_with_percentage
    UNION ALL
    SELECT *
    FROM total_member_with_percentage
    UNION ALL
    SELECT *
    FROM grade_member_with_percentage
    UNION ALL
    SELECT *
    FROM grade_new_old_member_with_percentage
    UNION ALL
    SELECT *
    FROM grade_new_old_member_recency_with_percentage;
