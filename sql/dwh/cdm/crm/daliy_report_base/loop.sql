INSERT INTO cdm_crm.daliy_report_base
    SELECT
        '全国',
        si.sales_area,
        si.city,
        oi.store_code,
        si.channel_type,
        oi.outer_order_no,
        oi.member_no,
        oi.order_grade,
        cast(
            IF(
                oi.member_no NOT IN ('-1', '-2'),
                IF(
                    date_format(oi.order_deal_time, '%Y-%m-%d') <= date_format(mfo.order_deal_time, '%Y-%m-%d'),
                    '新会员',
                    (
                        CASE oi.order_grade
                        WHEN 13 THEN '普通会员'
                        WHEN 14 THEN 'VIP会员'
                        ELSE NULL END
                    )
                ),
                '非会员'
            )
            AS VARCHAR
        ),
        oi.order_item_quantity,
        oi.order_amount,
        oi.order_fact_amount,
        mi.member_register_time,
        IF(oi.member_no != '-1', mgl.grade_change_time, NULL),
        oi.order_deal_time,
        localtimestamp
    FROM
        ods_crm.order_info oi
    LEFT JOIN
        ods_crm.store_info si
    ON
        oi.store_code = si.store_code
    LEFT JOIN
        ods_crm.member_first_order mfo
    ON
        oi.member_no = mfo.member_no
    LEFT JOIN
        ods_crm.member_info mi
    ON
        oi.member_no = mi.member_no
    LEFT JOIN (
        SELECT
            oi_t.member_no,
            oi_t.outer_order_no,
            oi_t.order_deal_time,
            max(mgl_t.grade_change_time)  grade_change_time
        FROM
            ods_crm.order_info oi_t
        LEFT JOIN
            ods_crm.member_grade_log mgl_t
        ON
            oi_t.member_no = mgl_t.member_no
            AND date_format(oi_t.order_deal_time, '%Y-%m-%d') >= date_format(mgl_t.grade_change_time, '%Y-%m-%d')
        GROUP BY
            oi_t.member_no,
            oi_t.outer_order_no,
            oi_t.order_deal_time
    ) mgl
    ON
        oi.member_no = mgl.member_no
        AND oi.outer_order_no = mgl.outer_order_no
        AND oi.order_deal_time = mgl.order_deal_time
    WHERE
        si.channel_type = '自营'
        AND date_format(oi.order_deal_time, '%Y-%m-%d %T') > (
            SELECT date_format(max(order_deal_time), '%Y-%m-%d %T')
            FROM ods_crm.daliy_report_base
        )
        AND date_format(oi.order_deal_time, '%Y-%m-%d %T') <= date_format(localtimestamp, '%Y-%m-%d %T');