INSERT INTO cdm_crm.daliy_report_store_day_base
    SELECT DISTINCT
        mtl.country,
        mtl.sales_area,
        mtl.city,
        mtl.store_code,
        -- 客户类型
        mtl.member_type,
        -- 销售金额
        IF(sm.sales_amount IS NOT NULL, sm.sales_amount, 0),
        -- 吊牌金额
        IF(rm.retail_amount IS NOT NULL, rm.retail_amount, 0),
        -- 单数
        IF(om.order_amount IS NOT NULL, om.order_amount, 0),
        -- 总销售金额
        IF(sm_tt.total_order_fact_amount IS NOT NULL, sm_tt.total_order_fact_amount, 0),
        -- 会员总销售金额
        IF(sm_mb_tt.total_order_fact_amount IS NOT NULL, sm_mb_tt.total_order_fact_amount, 0),
        -- 销售金额占比汇总
        cast(IF(
            sm_tt.total_order_fact_amount != 0,
            sm_mb_tt.total_order_fact_amount * 1.0 / sm_tt.total_order_fact_amount,
            0
        ) AS DECIMAL(18, 4)),
        -- 去年同期销售金额
        IF(lyst.last_year_same_time_sales_amount IS NOT NULL, lyst.last_year_same_time_sales_amount, 0),
        -- 销售件数
        IF(siq.sales_item_quantity IS NOT NULL, siq.sales_item_quantity, 0),
        -- 消费会员
        IF(mm.member_amount IS NOT NULL, mm.member_amount, 0),
        -- 上月存量
        IF(lmr.past_12_month_remain_member_amount IS NOT NULL, lmr.past_12_month_remain_member_amount, 0),
        -- 会员招募-VIP
        IF(new_vip.new_vip_member_amount IS NOT NULL, new_vip.new_vip_member_amount, 0),
        -- 会员招募-普通会员
        IF(new_normal.new_normal_member_amount IS NOT NULL, new_normal.new_normal_member_amount, 0),
        -- 会员升级
        IF(ugm.upgraded_member_amount IS NOT NULL, ugm.upgraded_member_amount, 0),
        -- 店铺数
        1,
        -- 店均消费总数
        IF(mm.member_amount IS NOT NULL, mm.member_amount, 0),
        -- 订单日期
        date(drb.order_deal_time)
    FROM
        ods_crm.daliy_report_base drb
    RIGHT JOIN
        ods_crm.member_type_label mtl
    ON
        drb.store_code = mtl.store_code

    -- 消费金额
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            cast(sum(drb.order_fact_amount) AS DECIMAL(38, 2))  sales_amount,
            date(drb.order_deal_time)  order_deal_date
        FROM
            ods_crm.daliy_report_base drb
        GROUP BY
            drb.store_code,
            drb.member_type,
            date(drb.order_deal_time)
    ) sm
    ON
        mtl.store_code = sm.store_code
        AND mtl.member_type = sm.member_type
        AND date(drb.order_deal_time) = sm.order_deal_date

    -- 吊牌金额
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            cast(sum(drb.order_amount) AS DECIMAL(38, 2))  retail_amount,
            date(drb.order_deal_time)  order_deal_date
        FROM
            ods_crm.daliy_report_base drb
        GROUP BY
            drb.store_code,
            drb.member_type,
            date(drb.order_deal_time)
    ) rm
    ON
        mtl.store_code = rm.store_code
        AND mtl.member_type = rm.member_type
        AND date(drb.order_deal_time) = rm.order_deal_date

    -- 单数
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            cast(count(distinct drb.outer_order_no) AS INTEGER)  order_amount,
            date(drb.order_deal_time)  order_deal_date
        FROM
            ods_crm.daliy_report_base drb
        GROUP BY
            drb.store_code,
            drb.member_type,
            date(drb.order_deal_time)
    ) om
    ON
        mtl.store_code = om.store_code
        AND mtl.member_type = om.member_type
        AND date(drb.order_deal_time) = om.order_deal_date

    -- 总消费金额(包括会员和非会员)
    LEFT JOIN (
        SELECT
            sales_area,
            city,
            store_code,
            cast(sum(order_fact_amount) AS DECIMAL(18, 2)) total_order_fact_amount,
            date(order_deal_time)  order_deal_date
        FROM
            ods_crm.daliy_report_base
        GROUP BY
            sales_area,
            city,
            store_code,
            date(order_deal_time)
    ) sm_tt
    ON
        mtl.sales_area = sm_tt.sales_area
        AND mtl.city = sm_tt.city
        AND mtl.store_code = sm_tt.store_code
        AND date(drb.order_deal_time) = sm_tt.order_deal_date

    -- 会员消费金额
    LEFT JOIN (
        SELECT
            sales_area,
            city,
            store_code,
            cast(sum(order_fact_amount) AS DECIMAL(18, 2)) total_order_fact_amount,
            date(order_deal_time)  order_deal_date
        FROM
            ods_crm.daliy_report_base
        WHERE
            member_type != '非会员'
        GROUP BY
            sales_area,
            city,
            store_code,
            date(order_deal_time)
    ) sm_mb_tt
    ON
        mtl.sales_area = sm_mb_tt.sales_area
        AND mtl.city = sm_mb_tt.city
        AND mtl.store_code = sm_mb_tt.store_code
        AND date(drb.order_deal_time) = sm_mb_tt.order_deal_date

    -- 去年同期
    LEFT JOIN (
        SELECT
            drb.sales_area,
            drb.city,
            drb.store_code,
            drb.member_type,
            cast(sum(drb.order_fact_amount) AS DECIMAL(38, 2))  last_year_same_time_sales_amount,
            date(drb.order_deal_time)                           order_deal_date
        FROM
            ods_crm.daliy_report_base drb
        GROUP BY
            drb.sales_area,
            drb.city,
            drb.store_code,
            drb.member_type,
            date(drb.order_deal_time)
    ) lyst
    ON
        mtl.store_code = lyst.store_code
        AND mtl.member_type = lyst.member_type
        AND date(drb.order_deal_time - interval '1' year) = lyst.order_deal_date
    
    -- 销售件数
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            cast(sum(drb.order_item_quantity) AS INTEGER)  sales_item_quantity,
            date(drb.order_deal_time)  order_deal_date
        FROM
            ods_crm.daliy_report_base drb
        GROUP BY
            drb.store_code,
            drb.member_type,
            date(drb.order_deal_time)
    ) siq
    ON
        mtl.store_code = siq.store_code
        AND mtl.member_type = siq.member_type
        AND date(drb.order_deal_time) = siq.order_deal_date

    -- 消费会员
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            cast(count(distinct drb.member_no) AS INTEGER)  member_amount,
            date(drb.order_deal_time)  order_deal_date
        FROM
            ods_crm.daliy_report_base drb
        GROUP BY
            drb.store_code,
            drb.member_type,
            date(drb.order_deal_time)
    ) mm
    ON
        mtl.store_code = mm.store_code
        AND mtl.member_type = mm.member_type
        AND date(drb.order_deal_time) = mm.order_deal_date

    -- 上月存量
    LEFT JOIN (
        SELECT
            t1.sales_area,
            t1.city,
            t1.store_code,
            t1.member_type,
            cast(count(distinct t2.member_no) AS INTEGER)  past_12_month_remain_member_amount,
            date(t1.order_deal_time)                       order_deal_date
        FROM
            ods_crm.daliy_report_base t1
        LEFT JOIN
            ods_crm.daliy_report_base t2
        ON
            t1.member_type IN ('普通会员', 'VIP会员')
            AND t1.sales_area = t2.sales_area
            AND t1.city = t2.city
            AND t1.store_code = t2.store_code
            AND t1.member_type = t2.member_type
            AND date(t1.order_deal_time) - interval '1' day >= date(t2.order_deal_time)
            AND date(t1.order_deal_time) - interval '12' month <= date(t2.order_deal_time)
        GROUP BY
            t1.sales_area,
            t1.city,
            t1.store_code,
            t1.member_type,
            date(t1.order_deal_time)
    ) lmr
    ON 
        mtl.store_code = lmr.store_code
        AND mtl.member_type = lmr.member_type
        AND date(drb.order_deal_time) = lmr.order_deal_date
    
    -- 会员招募-VIP
    LEFT JOIN (
        SELECT
            sales_area,
            city,
            store_code,
            member_type,
            cast(count(distinct member_no) AS INTEGER)  new_vip_member_amount,
            date(order_deal_time)                       order_deal_date
        FROM
            ods_crm.daliy_report_base
        WHERE
            member_type = '新会员'
            AND date(member_register_time) = date(order_deal_time)
            AND last_grade_change_time IS NOT NULL
        GROUP BY
            sales_area,
            city,
            store_code,
            member_type,
            date(order_deal_time)
    ) new_vip
    ON
        mtl.store_code = new_vip.store_code
        AND mtl.member_type = new_vip.member_type
        AND date(drb.order_deal_time) = new_vip.order_deal_date

    -- 会员招募-普通会员
    LEFT JOIN (
        SELECT
            sales_area,
            city,
            store_code,
            member_type,
            cast(count(distinct member_no) AS INTEGER)  new_normal_member_amount,
            date(order_deal_time)                       order_deal_date
        FROM
            ods_crm.daliy_report_base
        WHERE
            member_type = '新会员'
            AND date(member_register_time) = date(order_deal_time)
            AND last_grade_change_time IS NULL
        GROUP BY
            sales_area,
            city,
            store_code,
            member_type,
            date(order_deal_time)
    ) new_normal
    ON
        mtl.store_code = new_normal.store_code
        AND mtl.member_type = new_normal.member_type
        AND date(drb.order_deal_time) = new_normal.order_deal_date

    -- 会员升级
    LEFT JOIN (
        SELECT
            sales_area,
            city,
            store_code,
            member_type,
            cast(count(distinct member_no) AS INTEGER)  upgraded_member_amount,
            date(order_deal_time)                       order_deal_date
        FROM
            ods_crm.daliy_report_base
        WHERE
            member_type IN ('新会员', '普通会员')
            AND date(last_grade_change_time) = date(order_deal_time)
        GROUP BY
            sales_area,
            city,
            store_code,
            member_type,
            date(order_deal_time)
    ) ugm
    ON
        mtl.store_code = ugm.store_code
        AND mtl.member_type = ugm.member_type
        AND date(drb.order_deal_time) = ugm.order_deal_date;