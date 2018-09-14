    SELECT DISTINCT
        -- 区域
        mtl.country  AS sales_area,
        -- 城市
        'city',
        -- 门店
        'store',
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
            IF(sm_tt.total_order_fact_amount IS NOT NULL, sm_tt.total_order_fact_amount, 0) != 0,
            IF(sm_mb_tt.total_order_fact_amount IS NOT NULL, sm_mb_tt.total_order_fact_amount, 0) * 1.0 / sm_tt.total_order_fact_amount,
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
        IF(stm.store_amount IS NOT NULL, stm.store_amount, 0)  AS store_amount,
        -- 店均消费总数
        cast(IF (
            IF(stm.store_amount IS NOT NULL, stm.store_amount, 0) != 0,
            IF(mm.member_amount IS NOT NULL, mm.member_amount, 0) * 1.0 / IF(stm.store_amount IS NOT NULL, stm.store_amount, 0),
            0
        ) AS DECIMAL(18, 2))  AS member_amount_per_store,
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
        ) AS DECIMAL(18, 2))  AS order_amount_per_member
    FROM (
        SELECT DISTINCT
            country,
            member_type
        FROM
            cdm_crm.member_type_label
    ) mtl

    -- 消费金额
    LEFT JOIN (
        SELECT
            drb.country,
            drb.member_type,
            cast(sum(drb.order_fact_amount) AS DECIMAL(38, 2))  sales_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
        GROUP BY
            drb.country,
            drb.member_type
    ) sm
    ON
        mtl.country = sm.country
        AND mtl.member_type = sm.member_type

    -- 吊牌金额
    LEFT JOIN (
        SELECT
            drb.country,
            drb.member_type,
            cast(sum(drb.order_amount) AS DECIMAL(38, 2))  retail_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
        GROUP BY
            drb.country,
            drb.member_type
    ) rm
    ON
        mtl.country = rm.country
        AND mtl.member_type = rm.member_type

    -- 单数
    LEFT JOIN (
        SELECT
            drb.country,
            drb.member_type,
            cast(count(distinct drb.outer_order_no) AS INTEGER)  order_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
        GROUP BY
            drb.country,
            drb.member_type
    ) om
    ON
        mtl.country = om.country
        AND mtl.member_type = om.member_type

    -- 总消费金额(包括会员和非会员)
    LEFT JOIN (
        SELECT
            drb.country,
            cast(sum(drb.order_fact_amount) AS DECIMAL(18, 2)) total_order_fact_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
        GROUP BY
            drb.country
    ) sm_tt
    ON
        mtl.country = sm_tt.country

    -- 会员消费金额
    LEFT JOIN (
        SELECT
            drb.country,
            cast(sum(drb.order_fact_amount) AS DECIMAL(18, 2)) total_order_fact_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
            AND drb.member_type != '非会员'
        GROUP BY
            drb.country
    ) sm_mb_tt
    ON
        mtl.country = sm_mb_tt.country

    -- 去年同期
    LEFT JOIN (
        SELECT
            drb.country,
            drb.member_type,
            cast(sum(drb.order_fact_amount) AS DECIMAL(38, 2))  last_year_same_time_sales_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date(date({end_date}) - interval '1' year)
            AND date(drb.order_deal_time) >= date(date({start_date}) - interval '1' year)
        GROUP BY
            drb.country,
            drb.member_type
    ) lyst
    ON
        mtl.country = lyst.country
        AND mtl.member_type = lyst.member_type
    
    -- 销售件数
    LEFT JOIN (
        SELECT
            drb.country,
            drb.member_type,
            cast(sum(drb.order_item_quantity) AS INTEGER)  sales_item_quantity
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
        GROUP BY
            drb.country,
            drb.member_type
    ) siq
    ON
        mtl.country = siq.country
        AND mtl.member_type = siq.member_type

    -- 消费会员
    LEFT JOIN (
        SELECT
            drb.country,
            drb.member_type,
            cast(count(distinct drb.member_no) AS INTEGER)  member_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
        GROUP BY
            drb.country,
            drb.member_type
    ) mm
    ON
        mtl.country = mm.country
        AND mtl.member_type = mm.member_type

    -- 上月存量
    LEFT JOIN (
        SELECT
            drb.country,
            drb.member_type,
            count(distinct drb.member_no)  past_12_month_remain_member_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            drb.member_type IN ('普通会员', 'VIP会员')
            AND date(drb.order_deal_time) <= date(date({start_date}) - interval '1' day)
            AND date(drb.order_deal_time) >= date(date({start_date}) - interval '12' month)
        GROUP BY
            drb.country,
            drb.member_type
    ) lmr
    ON
        mtl.country = lmr.country
        AND mtl.member_type = lmr.member_type
    
    -- 会员招募-VIP
    LEFT JOIN (
        SELECT
            drb.country,
            drb.member_type,
            cast(count(distinct drb.member_no) AS INTEGER)  new_vip_member_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            drb.member_type = '新会员'
            AND date(drb.member_register_time) = date(drb.order_deal_time)
            AND drb.last_grade_change_time IS NOT NULL
            AND date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
        GROUP BY
            drb.country,
            drb.member_type
    ) new_vip
    ON
        mtl.country = new_vip.country
        AND mtl.member_type = new_vip.member_type

    -- 会员招募-普通会员
    LEFT JOIN (
        SELECT
            drb.country,
            drb.member_type,
            cast(count(distinct drb.member_no) AS INTEGER)  new_normal_member_amount
        FROM
            cdm_crm.daliy_report_base drb
        
        WHERE
            drb.member_type = '新会员'
            AND drb.last_grade_change_time IS NULL
            AND date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
        GROUP BY
            drb.country,
            drb.member_type
    ) new_normal
    ON
        mtl.country = new_normal.country
        AND mtl.member_type = new_normal.member_type

    -- 会员升级
    LEFT JOIN (
        SELECT
            drb.country,
            drb.member_type,
            cast(count(distinct drb.member_no) AS INTEGER)  upgraded_member_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            drb.member_type IN ('新会员', '普通会员')
            AND date(drb.last_grade_change_time) = date(drb.order_deal_time)
            AND date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
        GROUP BY
            drb.country,
            drb.member_type
    ) ugm
    ON
        mtl.country = ugm.country
        AND mtl.member_type = ugm.member_type

    -- 店铺数
    LEFT JOIN (
        SELECT
            drb.country,
            cast(count(distinct drb.store_code) AS INTEGER)  store_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date}) 
        GROUP BY
            drb.country
    ) stm
    ON
        mtl.country = stm.country

    WHERE
        mtl.member_type != '非会员';
