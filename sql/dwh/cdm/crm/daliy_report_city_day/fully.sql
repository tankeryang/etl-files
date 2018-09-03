DELETE FROM cdm_crm.daliy_report_city_day;


INSERT INTO cdm_crm.daliy_report_city_day
    SELECT
        sales_area,
        city,
        store_code,
        -- 销售(累计)
        member_type,
        sales_amount,
        sales_amount_proportion,
        sales_amount_proportion_total,
        IF(last_year_same_time_sales_amount IS NOT NULL, last_year_same_time_sales_amount, 0),
        like_for_like_sales_growth,
        sales_item_quantity,
        discount_rate,
        -- 会员基数(累计)
        member_amount,
        past_12_month_remain_member_amount,
        second_trade_rate,
        new_vip_member_amount,
        new_normal_member_amount,
        upgraded_member_amount,
        IF(store_amount IS NOT NULL, store_amount, 0),
        member_amount_per_store,
        sales_amount_per_member,
        sales_item_quantity_per_member,
        su_per_member,
        order_amount_per_member,
        order_deal_date
    FROM (
        SELECT
            drsdb.sales_area  AS sales_area,
            drsdb.city  AS city,
            NULL  AS store_code,
            drsdb.member_type  AS member_type,
            -- 销售金额
            cast(sum(drsdb.sales_amount) AS DECIMAL(38, 2))  AS sales_amount,
            -- 销售金额占比
            cast(IF (
                sum(drsdb.total_sales_amount) != 0,
                sum(drsdb.sales_amount) * 1.0 / sum(drsdb.total_sales_amount),
                0
            ) AS DECIMAL(18, 4))  AS sales_amount_proportion,
            -- 销售金额占比汇总
            cast(IF (
                sum(drsdb.total_sales_amount) != 0,
                sum(drsdb.member_total_sales_amount) * 1.0 / sum(drsdb.total_sales_amount),
                0
            ) AS DECIMAL(18, 4))  AS sales_amount_proportion_total,
            -- 去年同期销售金额
            lyst.last_year_same_time_sales_amount  AS last_year_same_time_sales_amount,
            -- 销售同比增长
            cast(IF (
                lyst.last_year_same_time_sales_amount != 0,
                (sum(drsdb.sales_amount) - lyst.last_year_same_time_sales_amount) * 1.0 / lyst.last_year_same_time_sales_amount,
                0
            ) AS DECIMAL(18, 4))  AS like_for_like_sales_growth,
            -- 销售件数
            cast(sum(drsdb.sales_item_quantity) AS INTEGER)  AS sales_item_quantity,
            -- 折扣
            cast(IF (
                sum(drsdb.retail_amount) != 0,
                sum(drsdb.sales_amount) * 1.0 / sum(drsdb.retail_amount),
                0
            ) AS DECIMAL(18, 2))  AS discount_rate,
            -- 消费会员
            cast(sum(drsdb.member_amount) AS INTEGER)  AS member_amount,
            -- 上月存量
            cast(sum(drsdb.past_12_month_remain_member_amount) AS INTEGER)  AS past_12_month_remain_member_amount,
            -- 回头率
            cast(IF (
                sum(drsdb.past_12_month_remain_member_amount) != 0,
                sum(drsdb.member_amount) * 1.0 / sum(drsdb.past_12_month_remain_member_amount),
                0
            ) AS DECIMAL(18, 4))  AS second_trade_rate,
            -- 会员招募-VIP
            cast(sum(drsdb.new_vip_member_amount) AS INTEGER)  AS new_vip_member_amount,
            -- 会员招募-普通会员
            cast(sum(drsdb.new_normal_member_amount) AS INTEGER)  AS new_normal_member_amount,
            -- 会员升级
            cast(sum(drsdb.upgraded_member_amount) AS INTEGER)  AS upgraded_member_amount,
            -- 店铺数
            stm.store_amount  AS store_amount,
            -- 店均消费总数
            cast(sum(drsdb.member_amount) * 1.0 / stm.store_amount AS DECIMAL(18, 2))  AS member_amount_per_store,
            -- 人均销售金额
            cast(IF (
                sum(drsdb.member_amount) != 0,
                sum(drsdb.sales_amount) * 1.0 / sum(drsdb.member_amount),
                0
            ) AS DECIMAL(18, 2))  AS sales_amount_per_member,
            -- 人均销售件数
            cast(IF (
                sum(drsdb.member_amount) != 0,
                sum(drsdb.sales_item_quantity) * 1.0 / sum(drsdb.member_amount),
                0
            ) AS DECIMAL(18, 2))  AS sales_item_quantity_per_member,
            -- 人均SU
            cast(IF (
                sum(drsdb.order_amount) != 0,
                sum(drsdb.sales_item_quantity) * 1.0 / sum(drsdb.order_amount),
                0
            ) AS DECIMAL(18, 2))  AS su_per_member,
            -- 人均次
            cast(IF (
                sum(drsdb.member_amount) != 0,
                sum(drsdb.order_amount) * 1.0 / sum(drsdb.member_amount),
                0
            ) AS DECIMAL(18, 2))  AS order_amount_per_member,
            drsdb.order_deal_date  AS order_deal_date
        FROM
            cdm_crm.daliy_report_store_day_base drsdb
        
        -- 上月存量
        LEFT JOIN (
            SELECT
                drsdb.sales_area,
                drsdb.city,
                drsdb.member_type,
                cast(IF(sum(drsdb.sales_amount) IS NOT NULL, sum(drsdb.sales_amount), 0) AS DECIMAL(38, 2))  last_year_same_time_sales_amount,
                drsdb.order_deal_date
            FROM
                cdm_crm.daliy_report_store_day_base drsdb
            GROUP BY
                drsdb.sales_area,
                drsdb.city,
                drsdb.member_type,
                drsdb.order_deal_date
        ) lyst
        ON
            drsdb.city = lyst.city
            AND drsdb.member_type = lyst.member_type
            AND date(drsdb.order_deal_date - interval '1' year) = lyst.order_deal_date

        -- 店铺数
        LEFT JOIN (
            SELECT
                drsdb.city,
                cast(count(distinct drsdb.store_code) AS INTEGER)  store_amount,
                drsdb.order_deal_date
            FROM
                cdm_crm.daliy_report_store_day_base drsdb
            GROUP BY
                drsdb.city,
                drsdb.order_deal_date
        ) stm
        ON
            drsdb.city = stm.city
            AND drsdb.order_deal_date = stm.order_deal_date

        GROUP BY
            drsdb.sales_area,
            drsdb.city,
            drsdb.member_type,
            lyst.last_year_same_time_sales_amount,
            stm.store_amount,
            drsdb.order_deal_date
    );