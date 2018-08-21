INSERT INTO cdm_crm.daliy_report_store_day
    SELECT DISTINCT
        mtl.sales_area,
        mtl.city,
        mtl.store_code,
        -- 客户类型
        mtl.member_type,
        -- 总销售金额
        IF(sm.sales_amount IS NOT NULL, sm.sales_amount, 0)  AS sales_amount,
        -- 销售金额占比
        cast(IF(
            IF(sm_tt.total_order_fact_amount IS NOT NULL, sm_tt.total_order_fact_amount, 0) != 0,
            IF(sm.sales_amount IS NOT NULL, sm.sales_amount, 0) * 1.0 / IF(sm_tt.total_order_fact_amount IS NOT NULL, sm_tt.total_order_fact_amount, 0),
            0
        ) AS DECIMAL(18, 4))  AS sales_amount_proportion,  
        -- 销售金额占比汇总
        cast(IF(
            sm_tt.total_order_fact_amount != 0,
            sm_mb_tt.total_order_fact_amount * 1.0 / sm_tt.total_order_fact_amount,
            0
        ) AS DECIMAL(18, 4))  AS sales_amount_proportion_total,
        -- 去年同期销售金额
        IF(lyst.last_year_same_time_sales_amount IS NOT NULL, lyst.last_year_same_time_sales_amount, 0)  AS last_year_same_time_sales_amount,
        -- 销售同比增长
        cast(IF(
            IF(lyst.last_year_same_time_sales_amount IS NOT NULL, lyst.last_year_same_time_sales_amount, 0) != 0,
            (IF(sm.sales_amount IS NOT NULL, sm.sales_amount, 0) - IF(lyst.last_year_same_time_sales_amount IS NOT NULL, lyst.last_year_same_time_sales_amount, 0)) * 1.0 / IF(lyst.last_year_same_time_sales_amount IS NOT NULL, lyst.last_year_same_time_sales_amount, 0),
            0
        ) AS DECIMAL(18, 4))  AS like_for_like_sales_growth,
        -- 销售件数
        IF(siq.sales_item_quantity IS NOT NULL, siq.sales_item_quantity, 0)  AS sales_item_quantity,
        -- 折扣
        cast(IF(
            IF(rm.retail_amount IS NOT NULL, rm.retail_amount, 0) != 0,
            IF(sm.sales_amount IS NOT NULL, sm.sales_amount, 0) * 1.0 / IF(rm.retail_amount IS NOT NULL, rm.retail_amount, 0),
            0
        ) AS DECIMAL(18, 2))  AS discount_rate,
        -- 消费会员
        IF(mm.member_amount IS NOT NULL, mm.member_amount, 0)  AS member_amount,
        -- 上月存量
        IF(lmr.past_12_month_remain_member_amount IS NOT NULL, lmr.past_12_month_remain_member_amount, 0)  AS past_12_month_remain_member_amount,
        -- 回头率
        cast(IF(
            IF(lmr.past_12_month_remain_member_amount IS NOT NULL, lmr.past_12_month_remain_member_amount, 0) != 0,
            IF(mm.member_amount IS NOT NULL, mm.member_amount, 0) * 1.0 / IF(lmr.past_12_month_remain_member_amount IS NOT NULL, lmr.past_12_month_remain_member_amount, 0),
            0
        ) AS DECIMAL(18, 4))  AS second_trade_rate,
        -- 会员招募-VIP
        IF(new_vip.new_vip_member_amount IS NOT NULL, new_vip.new_vip_member_amount, 0)  AS new_vip_member_amount,
        -- 会员招募-普通会员
        IF(new_normal.new_normal_member_amount IS NOT NULL, new_normal.new_normal_member_amount, 0)  AS new_normal_member_amount,
        -- 会员升级
        IF(ugm.upgraded_member_amount IS NOT NULL, ugm.upgraded_member_amount, 0)  AS upgraded_member_amount,
        -- 店铺数
        1  AS store_amount,
        -- 店均消费总数
        cast(IF(mm.member_amount IS NOT NULL, mm.member_amount, 0) AS DECIMAL(18, 2))  AS member_amount_per_store,
        -- 人均消售金额
        cast(IF (
            IF(mm.member_amount IS NOT NULL, mm.member_amount, 0) != 0,
            IF(sm.sales_amount IS NOT NULL, sm.sales_amount, 0) * 1.0 / IF(mm.member_amount IS NOT NULL, mm.member_amount, 0),
            0
        ) AS DECIMAL(18, 2))  AS sales_amount_per_member,
        -- 人均销售件数
        cast(IF (
            IF(mm.member_amount IS NOT NULL, mm.member_amount, 0) != 0,
            IF(siq.sales_item_quantity IS NOT NULL, siq.sales_item_quantity, 0) / IF(mm.member_amount IS NOT NULL, mm.member_amount, 0),
            0
        ) AS DECIMAL(18, 2))  AS sales_item_quantity_per_member,
        -- 人均SU
        cast(IF (
            IF(om.order_amount IS NOT NULL, om.order_amount, 0) != 0,
            IF(siq.sales_item_quantity IS NOT NULL, siq.sales_item_quantity, 0) * 1.0 / IF(om.order_amount IS NOT NULL, om.order_amount, 0),
            0
        ) AS DECIMAL(18, 2))  AS su_per_member,
        -- 人均次
        cast(IF (
            IF(mm.member_amount IS NOT NULL, mm.member_amount, 0) != 0,
            IF(om.order_amount IS NOT NULL, om.order_amount, 0) * 1.0 / IF(mm.member_amount IS NOT NULL, mm.member_amount, 0),
            0
        ) AS DECIMAL(18, 2))  AS order_amount_per_member,
        -- 订单日期
        date(drb.order_deal_time)
        -- 记录创建日期
        -- localtimestamp
    FROM
        cdm_crm.daliy_report_base drb
    RIGHT JOIN
        cdm_crm.member_type_label mtl
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
            cdm_crm.daliy_report_base drb
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
            cdm_crm.daliy_report_base drb
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
            cdm_crm.daliy_report_base drb
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
            drb.store_code,
            cast(sum(drb.order_fact_amount) AS DECIMAL(18, 2)) total_order_fact_amount,
            date(drb.order_deal_time)  order_deal_date
        FROM
            cdm_crm.daliy_report_base drb
        GROUP BY
            drb.store_code,
            date(drb.order_deal_time)
    ) sm_tt
    ON
        mtl.store_code = sm_tt.store_code
        AND date(drb.order_deal_time) = sm_tt.order_deal_date

    -- 会员消费金额
    LEFT JOIN (
        SELECT
            drb.store_code,
            cast(sum(drb.order_fact_amount) AS DECIMAL(18, 2)) total_order_fact_amount,
            date(drb.order_deal_time)  order_deal_date
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            drb.member_type != '非会员'
        GROUP BY
            drb.store_code,
            date(drb.order_deal_time)
    ) sm_mb_tt
    ON
        mtl.store_code = sm_mb_tt.store_code
        AND date(drb.order_deal_time) = sm_mb_tt.order_deal_date

    -- 去年同期
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            cast(sum(drb.order_fact_amount) AS DECIMAL(38, 2))  last_year_same_time_sales_amount,
            date(drb.order_deal_time)                           order_deal_date
        FROM
            cdm_crm.daliy_report_base drb
        GROUP BY
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
            cdm_crm.daliy_report_base drb
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
            cdm_crm.daliy_report_base drb
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
            t1.store_code,
            t1.member_type,
            cast(count(distinct t2.member_no) AS INTEGER)  past_12_month_remain_member_amount,
            date(t1.order_deal_time)                       order_deal_date
        FROM
            cdm_crm.daliy_report_base t1
        LEFT JOIN
            cdm_crm.daliy_report_base t2
        ON
            t1.store_code = t2.store_code
            AND t1.member_type = t2.member_type
            AND date(t1.order_deal_time) - interval '1' day >= date(t2.order_deal_time)
            AND date(t1.order_deal_time) - interval '12' month <= date(t2.order_deal_time)
        WHERE
            t1.member_type IN ('普通会员', 'VIP会员')
        GROUP BY
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
            drb.store_code,
            drb.member_type,
            cast(count(distinct drb.member_no) AS INTEGER)  new_vip_member_amount,
            date(drb.order_deal_time)                       order_deal_date
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            drb.member_type = '新会员'
            AND date(drb.member_register_time) = date(drb.order_deal_time)
            AND drb.last_grade_change_time IS NOT NULL
        GROUP BY
            drb.store_code,
            drb.member_type,
            date(drb.order_deal_time)
    ) new_vip
    ON
        mtl.store_code = new_vip.store_code
        AND mtl.member_type = new_vip.member_type
        AND date(drb.order_deal_time) = new_vip.order_deal_date

    -- 会员招募-普通会员
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            cast(count(distinct drb.member_no) AS INTEGER)  new_normal_member_amount,
            date(drb.order_deal_time)                       order_deal_date
        FROM
            cdm_crm.daliy_report_base drb
        
        WHERE
            drb.member_type = '新会员'
            AND date(drb.member_register_time) = date(drb.order_deal_time)
            AND drb.last_grade_change_time IS NULL
        GROUP BY
            drb.store_code,
            drb.member_type,
            date(drb.order_deal_time)
    ) new_normal
    ON
        mtl.store_code = new_normal.store_code
        AND mtl.member_type = new_normal.member_type
        AND date(drb.order_deal_time) = new_normal.order_deal_date

    -- 会员升级
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            cast(count(distinct drb.member_no) AS INTEGER)  upgraded_member_amount,
            date(drb.order_deal_time)                       order_deal_date
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            drb.member_type IN ('新会员', '普通会员')
            AND date(drb.last_grade_change_time) = date(drb.order_deal_time)
        GROUP BY
            drb.store_code,
            drb.member_type,
            date(drb.order_deal_time)
    ) ugm
    ON
        mtl.store_code = ugm.store_code
        AND mtl.member_type = ugm.member_type
        AND date(drb.order_deal_time) = ugm.order_deal_date;