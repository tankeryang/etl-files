DELETE FROM ads_crm.member_structure_active;


INSERT INTO ads_crm.member_structure_active (
    computing_until_month,
    computing_duration,
    channel_type,
    sales_area,
    store_region,
    member_type,
    frequency_type,
    recency_type,
    total_member_count,
    member_count_percentage,
    total_order_fact_amount,
    monetary_per_member,
    total_repurchased_member_count,
    total_repurchased_order_fact_amount,
    total_repurchased_percentage,
    member_existing_percentage,
    create_time,
    vchr_computing_until_month
    )
    WITH
        --***各渠道、区域下活跃新老客户-购买次数分组统计，客户数、成交额、人均成交额
        total_active_member_type_frequency_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            member_type,
            frequency_type,
            NULL           AS recency_type,
            total_member_count,
            total_order_fact_amount,
            monetary_per_member,
            NULL           AS total_repurchased_member_count,
            NULL           AS total_repurchased_order_fact_amount,
            NULL           AS total_repurchased_percentage,
            NULL           AS member_existing_percentage,
            LOCALTIMESTAMP AS create_time
            FROM cdm_crm.member_structure_active
            WHERE member_type = 'NEW' AND frequency_type IS NOT NULL AND recency_type IS NULL
            ORDER BY computing_until_month, computing_duration, channel_type, sales_area, store_region, member_type,
            frequency_type
        ),
        --***各渠道、区域下活跃-重复购买-新老客户统计，总客户数、总成交额、人均成交额、重复购买人数、重复购买金额、重复购买率
        total_active_n_repurchased_member_type_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            member_type,
            NULL           AS frequency_type,
            NULL           AS recency_type,
            total_member_count,
            total_order_fact_amount,
            monetary_per_member,
            total_repurchased_member_count,
            total_repurchased_order_fact_amount,
            total_repurchased_percentage,
            NULL           AS member_existing_percentage,
            LOCALTIMESTAMP AS create_time
            FROM cdm_crm.member_structure_active
            WHERE frequency_type IS NULL AND recency_type IS NULL
            ORDER BY computing_until_month, computing_duration, channel_type, sales_area, store_region, member_type
        ),
        --各渠道、区域下活跃新老客户-购买次数分组统计，客户数、成交额、人均成交额 + 人数占比
        total_active_member_type_frequency_member_with_percentage AS (
            SELECT
            frequncy.computing_until_month,
            frequncy.computing_duration,
            frequncy.channel_type,
            frequncy.sales_area,
            frequncy.store_region,
            frequncy.member_type,
            frequncy.frequency_type,
            NULL           AS recency_type,
            frequncy.total_member_count,
            COALESCE(TRY(CAST(frequncy.total_member_count * 1.00 / memberType.total_member_count AS DECIMAL(38, 4))),
                    0)    AS member_count_percentage,
            frequncy.total_order_fact_amount,
            frequncy.monetary_per_member,
            NULL           AS total_repurchased_member_count,
            NULL           AS total_repurchased_order_fact_amount,
            NULL           AS total_repurchased_percentage,
            NULL           AS member_existing_percentage,
            LOCALTIMESTAMP AS create_time,
            frequncy.computing_until_month
            FROM
            total_active_member_type_frequency_member frequncy, total_active_n_repurchased_member_type_member memberType
            WHERE frequncy.computing_until_month = memberType.computing_until_month AND
                frequncy.computing_duration = memberType.computing_duration AND
                ((frequncy.channel_type is null and memberType.channel_type is null) or frequncy.channel_type = memberType.channel_type) AND
                ((frequncy.sales_area is null and memberType.sales_area is null) or frequncy.sales_area = memberType.sales_area) AND
                ((frequncy.store_region is null and memberType.store_region is null) or frequncy.store_region = memberType.store_region) AND
                ((frequncy.member_type is null and memberType.member_type is null) or frequncy.member_type = memberType.member_type)
        ),
        --***活跃-重复购买统计，总客户数、总成交额、总人均成交额、总重复购买人数、总重复购买金额、总重复购买率
        total_active_n_repurchased_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            NULL           AS member_type,
            NULL           AS frequency_type,
            NULL           AS recency_type,
            total_member_count,
            1              AS member_count_percentage,
            total_order_fact_amount,
            monetary_per_member,
            total_repurchased_member_count,
            total_repurchased_order_fact_amount,
            total_repurchased_percentage,
            NULL           AS member_existing_percentage,
            LOCALTIMESTAMP AS create_time
            FROM total_active_n_repurchased_member_type_member
            WHERE member_type IS NULL AND frequency_type IS NULL AND recency_type IS NULL
        ),
        --各渠道、区域下活跃-重复购买-新老客户统计，总客户数、总成交额、人均成交额、重复购买人数、重复购买金额、重复购买率 + 人数占比
        total_active_n_repurchased_member_type_member_with_percentage AS (
            SELECT
            memberType.computing_until_month,
            memberType.computing_duration,
            memberType.channel_type,
            memberType.sales_area,
            memberType.store_region,
            memberType.member_type,
            NULL           AS frequency_type,
            NULL           AS recency_type,
            memberType.total_member_count,
            COALESCE(TRY(CAST(memberType.total_member_count * 1.00 / total.total_member_count AS DECIMAL(38, 4))),
                    0)    AS member_count_percentage,
            memberType.total_order_fact_amount,
            memberType.monetary_per_member,
            memberType.total_repurchased_member_count,
            memberType.total_repurchased_order_fact_amount,
            memberType.total_repurchased_percentage,
            NULL           AS member_existing_percentage,
            LOCALTIMESTAMP AS create_time,
            memberType.computing_until_month
            FROM total_active_n_repurchased_member_type_member memberType, total_active_n_repurchased_member total
            WHERE memberType.computing_until_month = total.computing_until_month AND
                memberType.computing_duration = total.computing_duration AND
                ((memberType.channel_type is null and total.channel_type is null) or memberType.channel_type = total.channel_type) AND
                ((memberType.sales_area is null and total.sales_area is null) or memberType.sales_area = total.sales_area) AND
                ((memberType.store_region is null and total.store_region is null) or memberType.store_region = total.store_region)
        ),
        --活跃老客户本月、季度、半年、年等之前的最近一次购买分布在上(及上上、上上上、...等)月、季度、半年、年等的哪个区间
        total_active_old_recency_type_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            'OLD' AS member_type,
            NULL  AS frequency_type,
            recency_type,
            total_member_count,
            total_order_fact_amount,
            monetary_per_member,
            NULL  AS total_repurchased_member_count,
            NULL  AS total_repurchased_order_fact_amount,
            NULL  AS total_repurchased_percentage
            FROM cdm_crm.member_structure_active
            WHERE member_type = 'OLD' AND frequency_type IS NULL AND recency_type IS NOT NULL
            ORDER BY computing_until_month, computing_duration, channel_type, sales_area, store_region, recency_type
        ),
        --***活跃老客户本月、季度、半年、年等之前的最近一次购买分布在上(及上上、上上上、...等)月、季度、半年、年等的哪个区间 + 客户保持率
        total_active_old_recency_type_member_with_existing_percentage AS (
            SELECT
            ortm.*,
            COALESCE(TRY(CAST(ortm.total_member_count * 1.00 /
                                nrm.total_member_count AS DECIMAL(38, 4))), 0) AS member_existing_percentage,
            LOCALTIMESTAMP                                                   AS create_time
            FROM total_active_old_recency_type_member ortm, total_active_n_repurchased_member nrm
            WHERE ortm.computing_until_month = nrm.computing_until_month AND
                ortm.computing_duration = nrm.computing_duration AND
                ((ortm.channel_type is null and nrm.channel_type is null) or ortm.channel_type = nrm.channel_type) AND
                ((ortm.sales_area is null and nrm.sales_area is null) or ortm.sales_area = nrm.sales_area) AND
                ((ortm.store_region is null and nrm.store_region is null) or ortm.store_region = nrm.store_region)
        ),
        --***活跃老客户本月、季度、半年、年等之前的最近一次购买分布在上(及上上、上上上、...等)月、季度、半年、年等的哪个区间 + 客户保持率 + 客户占比
        total_active_old_recency_type_member_with_existing_percentage_with_percentage AS (
            SELECT
            existing.computing_until_month,
            existing.computing_duration,
            existing.channel_type,
            existing.sales_area,
            existing.store_region,
            'OLD'          AS member_type,
            NULL           AS frequency_type,
            existing.recency_type,
            existing.total_member_count,
            COALESCE(TRY(CAST(existing.total_member_count * 1.00 / memberType.total_member_count AS DECIMAL(38, 4))),
                    0)    AS member_count_percentage,
            existing.total_order_fact_amount,
            existing.monetary_per_member,
            NULL           AS total_repurchased_member_count,
            NULL           AS total_repurchased_order_fact_amount,
            NULL           AS total_repurchased_percentage,
            existing.member_existing_percentage,
            LOCALTIMESTAMP AS create_time,
            existing.computing_until_month
            FROM total_active_old_recency_type_member_with_existing_percentage existing,
            total_active_n_repurchased_member_type_member memberType
            WHERE existing.computing_until_month = memberType.computing_until_month AND
                existing.computing_duration = memberType.computing_duration AND
                ((existing.channel_type is null and memberType.channel_type is null) or existing.channel_type = memberType.channel_type) AND
                ((existing.sales_area is null and memberType.sales_area is null) or existing.sales_area = memberType.sales_area) AND
                ((existing.store_region is null and memberType.store_region is null) or existing.store_region = memberType.store_region) AND
                ((existing.member_type is null and memberType.member_type is null) or existing.member_type = memberType.member_type)
        )

    SELECT *
    FROM total_active_member_type_frequency_member_with_percentage
    UNION ALL
    SELECT *
    FROM total_active_n_repurchased_member_type_member_with_percentage
    UNION ALL
    SELECT *
    FROM total_active_old_recency_type_member_with_existing_percentage_with_percentage;


INSERT INTO prod_mysql_crm_report_server.crm_mine.member_structure_active (
    computing_until_month,
    computing_duration,
    channel_type,
    sales_area,
    store_region,
    member_type,
    frequency_type,
    recency_type,
    total_member_count,
    member_count_percentage,
    total_order_fact_amount,
    monetary_per_member,
    total_repurchased_member_count,
    total_repurchased_order_fact_amount,
    total_repurchased_percentage,
    member_existing_percentage,
    create_time
    )
    WITH
        --***各渠道、区域下活跃新老客户-购买次数分组统计，客户数、成交额、人均成交额
        total_active_member_type_frequency_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            member_type,
            frequency_type,
            NULL           AS recency_type,
            total_member_count,
            total_order_fact_amount,
            monetary_per_member,
            NULL           AS total_repurchased_member_count,
            NULL           AS total_repurchased_order_fact_amount,
            NULL           AS total_repurchased_percentage,
            NULL           AS member_existing_percentage,
            LOCALTIMESTAMP AS create_time
            FROM cdm_crm.member_structure_active
            WHERE member_type = 'NEW' AND frequency_type IS NOT NULL AND recency_type IS NULL
            ORDER BY computing_until_month, computing_duration, channel_type, sales_area, store_region, member_type,
            frequency_type
        ),
        --***各渠道、区域下活跃-重复购买-新老客户统计，总客户数、总成交额、人均成交额、重复购买人数、重复购买金额、重复购买率
        total_active_n_repurchased_member_type_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            member_type,
            NULL           AS frequency_type,
            NULL           AS recency_type,
            total_member_count,
            total_order_fact_amount,
            monetary_per_member,
            total_repurchased_member_count,
            total_repurchased_order_fact_amount,
            total_repurchased_percentage,
            NULL           AS member_existing_percentage,
            LOCALTIMESTAMP AS create_time
            FROM cdm_crm.member_structure_active
            WHERE frequency_type IS NULL AND recency_type IS NULL
            ORDER BY computing_until_month, computing_duration, channel_type, sales_area, store_region, member_type
        ),
        --各渠道、区域下活跃新老客户-购买次数分组统计，客户数、成交额、人均成交额 + 人数占比
        total_active_member_type_frequency_member_with_percentage AS (
            SELECT
            frequncy.computing_until_month,
            frequncy.computing_duration,
            frequncy.channel_type,
            frequncy.sales_area,
            frequncy.store_region,
            frequncy.member_type,
            frequncy.frequency_type,
            NULL           AS recency_type,
            frequncy.total_member_count,
            COALESCE(TRY(CAST(frequncy.total_member_count * 1.00 / memberType.total_member_count AS DECIMAL(38, 4))),
                    0)    AS member_count_percentage,
            frequncy.total_order_fact_amount,
            frequncy.monetary_per_member,
            NULL           AS total_repurchased_member_count,
            NULL           AS total_repurchased_order_fact_amount,
            NULL           AS total_repurchased_percentage,
            NULL           AS member_existing_percentage,
            LOCALTIMESTAMP AS create_time,
            frequncy.computing_until_month
            FROM
            total_active_member_type_frequency_member frequncy, total_active_n_repurchased_member_type_member memberType
            WHERE frequncy.computing_until_month = memberType.computing_until_month AND
                frequncy.computing_duration = memberType.computing_duration AND
                ((frequncy.channel_type is null and memberType.channel_type is null) or frequncy.channel_type = memberType.channel_type) AND
                ((frequncy.sales_area is null and memberType.sales_area is null) or frequncy.sales_area = memberType.sales_area) AND
                ((frequncy.store_region is null and memberType.store_region is null) or frequncy.store_region = memberType.store_region) AND
                ((frequncy.member_type is null and memberType.member_type is null) or frequncy.member_type = memberType.member_type)
        ),
        --***活跃-重复购买统计，总客户数、总成交额、总人均成交额、总重复购买人数、总重复购买金额、总重复购买率
        total_active_n_repurchased_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            NULL           AS member_type,
            NULL           AS frequency_type,
            NULL           AS recency_type,
            total_member_count,
            1              AS member_count_percentage,
            total_order_fact_amount,
            monetary_per_member,
            total_repurchased_member_count,
            total_repurchased_order_fact_amount,
            total_repurchased_percentage,
            NULL           AS member_existing_percentage,
            LOCALTIMESTAMP AS create_time
            FROM total_active_n_repurchased_member_type_member
            WHERE member_type IS NULL AND frequency_type IS NULL AND recency_type IS NULL
        ),
        --各渠道、区域下活跃-重复购买-新老客户统计，总客户数、总成交额、人均成交额、重复购买人数、重复购买金额、重复购买率 + 人数占比
        total_active_n_repurchased_member_type_member_with_percentage AS (
            SELECT
            memberType.computing_until_month,
            memberType.computing_duration,
            memberType.channel_type,
            memberType.sales_area,
            memberType.store_region,
            memberType.member_type,
            NULL           AS frequency_type,
            NULL           AS recency_type,
            memberType.total_member_count,
            COALESCE(TRY(CAST(memberType.total_member_count * 1.00 / total.total_member_count AS DECIMAL(38, 4))),
                    0)    AS member_count_percentage,
            memberType.total_order_fact_amount,
            memberType.monetary_per_member,
            memberType.total_repurchased_member_count,
            memberType.total_repurchased_order_fact_amount,
            memberType.total_repurchased_percentage,
            NULL           AS member_existing_percentage,
            LOCALTIMESTAMP AS create_time,
            memberType.computing_until_month
            FROM total_active_n_repurchased_member_type_member memberType, total_active_n_repurchased_member total
            WHERE memberType.computing_until_month = total.computing_until_month AND
                memberType.computing_duration = total.computing_duration AND
                ((memberType.channel_type is null and total.channel_type is null) or memberType.channel_type = total.channel_type) AND
                ((memberType.sales_area is null and total.sales_area is null) or memberType.sales_area = total.sales_area) AND
                ((memberType.store_region is null and total.store_region is null) or memberType.store_region = total.store_region)
        ),
        --活跃老客户本月、季度、半年、年等之前的最近一次购买分布在上(及上上、上上上、...等)月、季度、半年、年等的哪个区间
        total_active_old_recency_type_member AS (
            SELECT
            computing_until_month,
            computing_duration,
            channel_type,
            sales_area,
            store_region,
            'OLD' AS member_type,
            NULL  AS frequency_type,
            recency_type,
            total_member_count,
            total_order_fact_amount,
            monetary_per_member,
            NULL  AS total_repurchased_member_count,
            NULL  AS total_repurchased_order_fact_amount,
            NULL  AS total_repurchased_percentage
            FROM cdm_crm.member_structure_active
            WHERE member_type = 'OLD' AND frequency_type IS NULL AND recency_type IS NOT NULL
            ORDER BY computing_until_month, computing_duration, channel_type, sales_area, store_region, recency_type
        ),
        --***活跃老客户本月、季度、半年、年等之前的最近一次购买分布在上(及上上、上上上、...等)月、季度、半年、年等的哪个区间 + 客户保持率
        total_active_old_recency_type_member_with_existing_percentage AS (
            SELECT
            ortm.*,
            COALESCE(TRY(CAST(ortm.total_member_count * 1.00 /
                                nrm.total_member_count AS DECIMAL(38, 4))), 0) AS member_existing_percentage,
            LOCALTIMESTAMP                                                   AS create_time
            FROM total_active_old_recency_type_member ortm, total_active_n_repurchased_member nrm
            WHERE ortm.computing_until_month = nrm.computing_until_month AND
                ortm.computing_duration = nrm.computing_duration AND
                ((ortm.channel_type is null and nrm.channel_type is null) or ortm.channel_type = nrm.channel_type) AND
                ((ortm.sales_area is null and nrm.sales_area is null) or ortm.sales_area = nrm.sales_area) AND
                ((ortm.store_region is null and nrm.store_region is null) or ortm.store_region = nrm.store_region)
        ),
        --***活跃老客户本月、季度、半年、年等之前的最近一次购买分布在上(及上上、上上上、...等)月、季度、半年、年等的哪个区间 + 客户保持率 + 客户占比
        total_active_old_recency_type_member_with_existing_percentage_with_percentage AS (
            SELECT
            existing.computing_until_month,
            existing.computing_duration,
            existing.channel_type,
            existing.sales_area,
            existing.store_region,
            'OLD'          AS member_type,
            NULL           AS frequency_type,
            existing.recency_type,
            existing.total_member_count,
            COALESCE(TRY(CAST(existing.total_member_count * 1.00 / memberType.total_member_count AS DECIMAL(38, 4))),
                    0)    AS member_count_percentage,
            existing.total_order_fact_amount,
            existing.monetary_per_member,
            NULL           AS total_repurchased_member_count,
            NULL           AS total_repurchased_order_fact_amount,
            NULL           AS total_repurchased_percentage,
            existing.member_existing_percentage,
            LOCALTIMESTAMP AS create_time,
            existing.computing_until_month
            FROM total_active_old_recency_type_member_with_existing_percentage existing,
            total_active_n_repurchased_member_type_member memberType
            WHERE existing.computing_until_month = memberType.computing_until_month AND
                existing.computing_duration = memberType.computing_duration AND
                ((existing.channel_type is null and memberType.channel_type is null) or existing.channel_type = memberType.channel_type) AND
                ((existing.sales_area is null and memberType.sales_area is null) or existing.sales_area = memberType.sales_area) AND
                ((existing.store_region is null and memberType.store_region is null) or existing.store_region = memberType.store_region) AND
                ((existing.member_type is null and memberType.member_type is null) or existing.member_type = memberType.member_type)
        )

    SELECT *
    FROM total_active_member_type_frequency_member_with_percentage
    UNION ALL
    SELECT *
    FROM total_active_n_repurchased_member_type_member_with_percentage
    UNION ALL
    SELECT *
    FROM total_active_old_recency_type_member_with_existing_percentage_with_percentage;
