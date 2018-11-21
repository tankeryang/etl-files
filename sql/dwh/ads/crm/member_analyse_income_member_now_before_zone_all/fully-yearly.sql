INSERT INTO ads_crm.member_analyse_income_member_now_before_zone_all
    WITH coid AS (
        SELECT DISTINCT
            t_.brand_name,
            t_.{zone},
            t_.order_channel,
            t_.outer_order_no,
            t_.member_no,
            t_.member_grade_id,
            t_.member_type,
            _t.member_nowbefore_type,
            t_.order_item_quantity,
            t_.order_amount,
            t_.order_fact_amount,
            t_.member_register_time,
            t_.last_grade_change_time,
            t_.order_deal_time
        FROM cdm_crm.order_info_detail t_
        LEFT JOIN (
            SELECT DISTINCT date(member_register_time) member_register_date,
            IF( year(member_register_time) = year(date(localtimestamp)),
                IF(month(member_register_time) = month(date(localtimestamp)), '当月会员', '当年会员'),
                IF(year(member_register_time) < year(date(localtimestamp)), '往年会员', NULL)) member_nowbefore_type
            FROM cdm_crm.order_info_detail ) _t
        ON date(t_.member_register_time) = _t.member_register_date
        WHERE t_.member_type = '会员' AND date(t_.order_deal_time) <= date(localtimestamp)
    ), t1 AS (
        SELECT DISTINCT
            cmail.brand_name    AS brand,
            cmail.{zone}        AS zone,
            cmail.order_channel AS order_channel,
            cmail.member_type   AS member_type,
            sm.si               AS si,
            sm.ca               AS ca,
            sm.oa               AS oa,
            sm.siq              AS siq,
            smtt.ttsi           AS ttsi
        FROM (
            SELECT DISTINCT brand_name, {zone}, order_channel, member_type
            FROM cdm_crm.member_analyse_index_label
            WHERE member_type = '会员' ) cmail
        LEFT JOIN (
            SELECT brand_name, {zone}, order_channel, member_type,
            sum(coid.order_fact_amount) * 1.0   AS si,
            count(distinct coid.member_no)      AS ca,
            count(distinct coid.outer_order_no) AS oa,
            sum(coid.order_item_quantity)       AS siq
            FROM coid
            WHERE date(coid.order_deal_time) <= date(localtimestamp)
            AND date(coid.order_deal_time) >= date(date_format(localtimestamp, '%Y-01-01'))
            GROUP BY brand_name, {zone}, order_channel, member_type) sm
        ON cmail.brand_name = sm.brand_name
        AND cmail.{zone} = sm.{zone}
        AND cmail.order_channel = sm.order_channel
        AND cmail.member_type = sm.member_type
        LEFT JOIN (
            SELECT brand_name, {zone}, order_channel, sum(coid.order_fact_amount) * 1.0 AS ttsi
            FROM coid
            WHERE date(coid.order_deal_time) <= date(localtimestamp)
            AND date(coid.order_deal_time) >= date(date_format(localtimestamp, '%Y-01-01'))
            GROUP BY brand_name, {zone}, order_channel) smtt
        ON cmail.brand_name = smtt.brand_name
        AND cmail.{zone} = smtt.{zone}
        AND cmail.order_channel = smtt.order_channel
    ), t2 AS (
        SELECT DISTINCT
            cmail2.brand_name            AS brand,
            cmail2.{zone}                AS zone,
            cmail2.order_channel         AS order_channel,
            cmail2.member_nowbefore_type AS member_type,
            sm2.si                       AS si,
            sm2.ca                       AS ca,
            sm2.oa                       AS oa,
            sm2.siq                      AS siq,
            smtt2.ttsi                   AS ttsi
        FROM (
            SELECT DISTINCT brand_name, {zone}, order_channel, member_nowbefore_type
            FROM cdm_crm.member_analyse_index_label
            WHERE member_type = '会员') cmail2
        LEFT JOIN (
            SELECT brand_name, {zone}, order_channel, member_nowbefore_type,
            sum(coid.order_fact_amount) * 1.0   AS si,
            count(distinct member_no)           AS ca,
            count(distinct coid.outer_order_no) AS oa,
            sum(coid.order_item_quantity)       AS siq
            FROM coid
            WHERE date(coid.order_deal_time) <= date(localtimestamp)
            AND date(coid.order_deal_time) >= date(date_format(localtimestamp, '%Y-01-01'))
            GROUP BY brand_name, {zone}, order_channel, member_nowbefore_type) sm2
        ON cmail2.brand_name = sm2.brand_name
        AND cmail2.{zone} = sm2.{zone}
        AND cmail2.order_channel = sm2.order_channel
        AND cmail2.member_nowbefore_type = sm2.member_nowbefore_type
        LEFT JOIN (
            SELECT brand_name, {zone}, order_channel, sum(coid.order_fact_amount) * 1.0 AS ttsi
            FROM coid
            WHERE date(coid.order_deal_time) <= date(localtimestamp)
            AND date(coid.order_deal_time) >= date(date_format(localtimestamp, '%Y-01-01'))
            GROUP BY brand_name, {zone}, order_channel) smtt2
        ON cmail2.brand_name = smtt2.brand_name
        AND cmail2.{zone} = smtt2.{zone}
        AND cmail2.order_channel = smtt2.order_channel
    )
    SELECT DISTINCT
        t1.brand         AS brand,
        t1.order_channel AS order_channel,
        t1.zone          AS zone,
        '{zone}'         AS zone_type,
        t1.member_type   AS member_type,
        cast(COALESCE(SUM(t1.si), 0) AS DECIMAL(18, 3)) AS sales_income,
        cast(COALESCE(TRY(SUM(t1.si) * 1.0 / SUM(t1.ttsi)), 0) AS DECIMAL(18, 4)) AS sales_income_proportion,
        cast(COALESCE(SUM(t1.ca), 0) AS INTEGER) AS customer_amount,
        cast(COALESCE(SUM(t1.oa), 0) AS INTEGER) AS order_amount,
        cast(COALESCE(TRY(SUM(t1.oa) / SUM(t1.ca)), 0) AS INTEGER) AS consumption_frequency,
        cast(COALESCE(TRY(SUM(t1.si) * 1.0 / SUM(t1.oa)), 0) AS DECIMAL(18, 2)) AS sales_income_per_order,
        cast(COALESCE(TRY(SUM(t1.si) * 1.0 / SUM(t1.siq)), 0) AS DECIMAL(18, 2)) AS sales_income_per_item,
        cast(COALESCE(TRY(SUM(t1.siq) * 1.0 / SUM(t1.oa)), 0) AS DECIMAL(18, 2)) AS sales_item_per_order,
        'yearly' AS duration_type,
        localtimestamp AS create_time
    FROM t1 GROUP BY t1.brand, t1.order_channel, t1.zone, t1.member_type
    UNION SELECT DISTINCT
        t2.brand         AS brand,
        t2.order_channel AS order_channel,
        t2.zone          AS zone,
        '{zone}'         AS zone_type,
        t2.member_type   AS member_type,
        cast(COALESCE(SUM(t2.si), 0) AS DECIMAL(18, 3)) AS sales_income,
        cast(COALESCE(TRY(SUM(t2.si) * 1.0 / SUM(t2.ttsi)), 0) AS DECIMAL(18, 4)) AS sales_income_proportion,
        cast(COALESCE(SUM(t2.ca), 0) AS INTEGER) AS customer_amount,
        cast(COALESCE(SUM(t2.oa), 0) AS INTEGER) AS order_amount,
        cast(COALESCE(TRY(SUM(t2.oa) / SUM(t2.ca)), 0) AS INTEGER) AS consumption_frequency,
        cast(COALESCE(TRY(SUM(t2.si) * 1.0 / SUM(t2.oa)), 0) AS DECIMAL(18, 2)) AS sales_income_per_order,
        cast(COALESCE(TRY(SUM(t2.si) * 1.0 / SUM(t2.siq)), 0) AS DECIMAL(18, 2)) AS sales_income_per_item,
        cast(COALESCE(TRY(SUM(t2.siq) * 1.0 / SUM(t2.oa)), 0) AS DECIMAL(18, 2)) AS sales_item_per_order,
        'yearly' AS duration_type,
        localtimestamp AS create_time
    FROM t2 GROUP BY t2.brand, t2.order_channel, t2.zone, t2.member_type;
