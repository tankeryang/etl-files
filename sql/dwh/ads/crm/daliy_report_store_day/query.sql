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
        IF(sm.sales_item_quantity IS NOT NULL, sm.sales_item_quantity, 0)  AS sales_item_quantity,
        -- 折扣
        cast(IF(
            IF(sm.retail_amount IS NOT NULL, sm.retail_amount, 0) != 0,
            IF(sm.sales_amount IS NOT NULL, sm.sales_amount, 0) * 1.0 / IF(sm.retail_amount IS NOT NULL, sm.retail_amount, 0),
            0
        ) AS DECIMAL(18, 2))  AS discount_rate,
        -- 消费会员
        IF(sm.member_amount IS NOT NULL, sm.member_amount, 0)  AS member_amount,
        -- 上月存量
        IF(lmr.past_12_month_remain_member_amount IS NOT NULL, lmr.past_12_month_remain_member_amount, 0)  AS past_12_month_remain_member_amount,
        -- 回头率
        cast(IF(
            IF(lmr.past_12_month_remain_member_amount IS NOT NULL, lmr.past_12_month_remain_member_amount, 0) != 0,
            IF(sm.member_amount IS NOT NULL, sm.member_amount, 0) * 1.0 / IF(lmr.past_12_month_remain_member_amount IS NOT NULL, lmr.past_12_month_remain_member_amount, 0),
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
        IF(sm.member_amount IS NOT NULL, sm.member_amount, 0)  AS member_amount_per_store,
        -- 人均消售金额
        cast(IF (
            IF(sm.member_amount IS NOT NULL, sm.member_amount, 0) != 0,
            IF(sm.sales_amount IS NOT NULL, sm.sales_amount, 0) * 1.0 / IF(sm.member_amount IS NOT NULL, sm.member_amount, 0),
            0
        ) AS DECIMAL(18, 2))  AS sales_amount_per_member,
        -- 人均销售件数
        cast(IF (
            IF(sm.member_amount IS NOT NULL, sm.member_amount, 0) != 0,
            IF(sm.sales_item_quantity IS NOT NULL, sm.sales_item_quantity, 0) / IF(sm.member_amount IS NOT NULL, sm.member_amount, 0),
            0
        ) AS DECIMAL(18, 2))  AS sales_item_quantity_per_member,
        -- 人均SU
        cast(IF (
            IF(sm.order_amount IS NOT NULL, sm.order_amount, 0) != 0,
            IF(sm.sales_item_quantity IS NOT NULL, sm.sales_item_quantity, 0) * 1.0 / IF(sm.order_amount IS NOT NULL, sm.order_amount, 0),
            0
        ) AS DECIMAL(18, 2))  AS su_per_member,
        -- 人均次
        cast(IF (
            IF(sm.member_amount IS NOT NULL, sm.member_amount, 0) != 0,
            IF(sm.order_amount IS NOT NULL, sm.order_amount, 0) * 1.0 / IF(sm.member_amount IS NOT NULL, sm.member_amount, 0),
            0
        ) AS DECIMAL(18, 2))  AS order_amount_per_member
    FROM
        cdm_crm.member_type_label mtl

    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            -- 消费金额
            cast(sum(drb.order_fact_amount) AS DECIMAL(38, 2))  sales_amount,
            -- 吊牌金额
            cast(sum(drb.order_amount) AS DECIMAL(38, 2))  retail_amount,
            -- 单数
            cast(count(distinct drb.outer_order_no) AS INTEGER)  order_amount,
            -- 销售件数
            cast(sum(drb.order_item_quantity) AS INTEGER)  sales_item_quantity,
            -- 消费会员
            cast(count(distinct drb.member_no) AS INTEGER)  member_amount,
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
        GROUP BY
            drb.store_code,
            drb.member_type
    ) sm
    ON
        mtl.store_code = sm.store_code
        AND mtl.member_type = sm.member_type

    -- 总消费金额(包括会员和非会员)
    LEFT JOIN (
        SELECT
            drb.store_code,
            cast(sum(drb.order_fact_amount) AS DECIMAL(18, 2)) total_order_fact_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
        GROUP BY
            drb.store_code
    ) sm_tt
    ON
        mtl.store_code = sm_tt.store_code

    -- 会员消费金额
    LEFT JOIN (
        SELECT
            drb.store_code,
            cast(sum(drb.order_fact_amount) AS DECIMAL(18, 2)) total_order_fact_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
            AND drb.member_type != '非会员'
        GROUP BY
            drb.store_code
    ) sm_mb_tt
    ON
        mtl.store_code = sm_mb_tt.store_code

    -- 去年同期
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            cast(sum(drb.order_fact_amount) AS DECIMAL(38, 2))  last_year_same_time_sales_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date(date({end_date}) - interval '1' year)
            AND date(drb.order_deal_time) >= date(date({start_date}) - interval '1' year)
        GROUP BY
            drb.store_code,
            drb.member_type
    ) lyst
    ON
        mtl.store_code = lyst.store_code
        AND mtl.member_type = lyst.member_type

    -- 上月存量
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            count(distinct drb.member_no)  past_12_month_remain_member_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            date(drb.order_deal_time) <= date(date({end_date}) - interval '1' day)
            AND date(drb.order_deal_time) >= date(date({start_date}) - interval '12' month)
        GROUP BY
            drb.store_code,
            drb.member_type
    ) lmr
    ON
        mtl.store_code = lmr.store_code
        AND mtl.member_type = lmr.member_type
    
    -- 会员招募-VIP
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            cast(count(distinct drb.member_no) AS INTEGER)  new_vip_member_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            drb.member_type = '新会员'
            AND date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
            AND date(drb.member_register_time) = date(drb.order_deal_time)
            AND drb.last_grade_change_time IS NOT NULL
        GROUP BY
            drb.store_code,
            drb.member_type
    ) new_vip
    ON
        mtl.store_code = new_vip.store_code
        AND mtl.member_type = new_vip.member_type

    -- 会员招募-普通会员
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            cast(count(distinct drb.member_no) AS INTEGER)  new_normal_member_amount
        FROM
            cdm_crm.daliy_report_base drb
        
        WHERE
            drb.member_type = '新会员'
            AND date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
            AND drb.last_grade_change_time IS NULL
        GROUP BY
            drb.store_code,
            drb.member_type
    ) new_normal
    ON
        mtl.store_code = new_normal.store_code
        AND mtl.member_type = new_normal.member_type

    -- 会员升级
    LEFT JOIN (
        SELECT
            drb.store_code,
            drb.member_type,
            cast(count(distinct drb.member_no) AS INTEGER)  upgraded_member_amount
        FROM
            cdm_crm.daliy_report_base drb
        WHERE
            drb.member_type IN ('新会员', '普通会员')
            AND date(drb.order_deal_time) <= date({end_date})
            AND date(drb.order_deal_time) >= date({start_date})
        GROUP BY
            drb.store_code,
            drb.member_type
    ) ugm
    ON
        mtl.store_code = ugm.store_code
        AND mtl.member_type = ugm.member_type
    WHERE
        mtl.member_type != '非会员'
        AND mtl.store_code IN ({store_list});
