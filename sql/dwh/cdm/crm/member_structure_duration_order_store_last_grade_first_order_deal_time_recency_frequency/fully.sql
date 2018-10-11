DELETE FROM cdm_crm.member_structure_duration_order_store_last_grade_first_order_deal_time_recency_frequency;


INSERT INTO cdm_crm.member_structure_duration_order_store_last_grade_first_order_deal_time_recency_frequency (
    computing_until_month,
    computing_duration,
    channel_type,
    sales_area,
    store_region,
    grade_code,
    order_deal_time,
    member_frist_order_deal_time,
    member_type,
    recency,
    frequency,
    order_fact_amount,
    order_id,
    member_no
    )
    -- 会员购买渠道、购买所属销售区域、行政区域、等级、新老客户、最近购买时间间隔、累计消费金额、订单ID、会员ID
    -----------1, 3, 6, 12个月时间段------------------------------------------------------------------------------------------------
    WITH
        --时间段内客户最新等级、是否新客户、最近一次购买间隙
        duration_order_store_last_grade_first_order_deal_time_recency_frequency AS (
            SELECT
            dos.computing_until_month,
            dos.computing_duration,
            CASE WHEN dos.channel_type IS NULL
                THEN '-'
            ELSE dos.channel_type END AS channel_type,
            dos.sales_area,
            store_region,
    --           dmlg.grade_code,
            CASE WHEN dmlg.grade_code IS NULL
                THEN 'FIV_GENERAL_VIP'
            ELSE dmlg.grade_code END as grade_code,
            dos.order_deal_time,
            mfo.order_deal_time       as member_frist_order_deal_time,
            CASE WHEN mfo.order_deal_time >= date_trunc('month', CURRENT_DATE +
                                                                        INTERVAL '-{computing_duration}' MONTH) AND mfo.order_deal_time < date_trunc(
                'month', CURRENT_DATE)
                THEN 'NEW'
            ELSE 'OLD' END            AS member_type,
            dmr.recency,
            dmf.frequency,
            dos.order_fact_amount,
            dos.order_id,
            dos.member_no
            FROM cdm_crm.member_structure_duration_order_store dos
            LEFT JOIN member_structure_duration_member_last_grade dmlg
                ON dos.member_no = dmlg.member_no AND
                dos.computing_until_month = dmlg.computing_until_month AND
                dos.computing_duration = dmlg.computing_duration
            LEFT JOIN ods_crm.member_first_order mfo
                ON dos.member_no = mfo.member_no
            LEFT JOIN cdm_crm.member_structure_duration_member_recency dmr
                ON dos.member_no = dmr.member_no AND
                dos.computing_until_month = dmr.computing_until_month AND
                dos.computing_duration = dmr.computing_duration
            LEFT JOIN cdm_crm.member_structure_duration_member_frequency dmf
                ON dos.member_no = dmf.member_no AND
                dos.computing_until_month = dmf.computing_until_month AND
                dos.computing_duration = dmf.computing_duration
            WHERE dos.computing_duration = cast('{computing_duration}' AS INTEGER)
        )
    SELECT *
    FROM duration_order_store_last_grade_first_order_deal_time_recency_frequency;