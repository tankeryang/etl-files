-- 测试 province

SELECT DISTINCT
    matl.all  AS member_type,
    -- 销售收入(万元)
    cast(IF(sm.si IS NOT NULL, sm.si, 0) AS DECIMAL(10, 3)) AS sales_income,
    -- 销售收入占比(%)
    cast(IF(sm.sip IS NOT NULL, sm.sip, 0) AS DECIMAL(10, 2)) AS sales_income_proportion,
    -- 消费人数
    cast(IF(sm.ca IS NOT NULL, sm.ca, 0) AS INTEGER) AS customer_amount,
    -- 交易单数
    cast(IF(sm.oa IS NOT NULL, sm.oa, 0) AS INTEGER) AS order_amount,
    -- 消费频次
    cast(IF(IF(sm.ca IS NOT NULL, sm.ca, 0) != 0, IF(sm.oa IS NOT NULL, sm.oa, 0) / IF(sm.ca IS NOT NULL, sm.ca, 0), 0) AS INTEGER) AS consumption_frequency,
    -- 客单价
    cast(IF(IF(sm.oa IS NOT NULL, sm.oa, 0) != 0, IF(sm.si IS NOT NULL, sm.si, 0) * 10000.0 / IF(sm.oa IS NOT NULL, sm.oa, 0), 0) AS DECIMAL(10, 2)) AS sales_income_per_order,
    -- 件单价
    cast(IF(IF(sm.siq IS NOT NULL, sm.siq, 0) != 0, IF(sm.si IS NOT NULL, sm.si, 0) * 10000.0 / IF(sm.siq IS NOT NULL, sm.siq, 0), 0) AS DECIMAL(10, 2)) AS sales_income_per_item,
    -- 客单件
    cast(IF(IF(sm.oa IS NOT NULL, sm.oa, 0) != 0, IF(sm.siq IS NOT NULL, sm.siq, 0) / IF(sm.oa IS NOT NULL, sm.oa, 0), 0) AS INTEGER) AS sales_item_per_order,
    -- 同比
    cast(IF(IF(lyst.si IS NOT NULL, lyst.si, 0) != 0, (IF(sm.si IS NOT NULL, sm.si, 0) - IF(lyst.si IS NOT NULL, lyst.si, 0)) * 100.0 / IF(lyst.si IS NOT NULL, lyst.si, 0), 0) AS DECIMAL(10, 2)) AS sales_income_growth
FROM (
    SELECT DISTINCT
        province, order_channel, sales_mode, store_type, store_level, channel_type, all
    FROM cdm_crm.member_analyse_type_label
) matl

LEFT JOIN (
    SELECT province, order_channel, sales_mode, store_type, store_level, channel_type, all,
    sum(mab.order_fact_amount) * 1.0 / 10000  AS si,
    100.00                                    AS sip,
    count(distinct member_no)                 AS ca,
    count(distinct mab.outer_order_no)        AS oa,
    sum(mab.order_item_quantity)              AS siq
    FROM cdm_crm.member_analyse_base mab
    WHERE date(mab.order_deal_time) <= date('2018-08-01')
    AND date(mab.order_deal_time) >= date('2017-08-01')
    GROUP BY province, order_channel, sales_mode, store_type, store_level, channel_type, all
) sm
ON matl.province = sm.province
AND matl.order_channel = sm.order_channel
AND matl.sales_mode = sm.sales_mode
AND matl.store_type = sm.store_type
AND matl.store_level = sm.store_level
AND matl.channel_type = sm.channel_type
AND matl.all = sm.all

LEFT JOIN (
    SELECT province, order_channel, sales_mode, store_type, store_level, channel_type, all,
    sum(mab.order_fact_amount) * 1.0 / 10000  AS si
    FROM cdm_crm.member_analyse_base mab
    WHERE date(mab.order_deal_time) <= date(date('2018-08-01') - interval '1' year)
    AND date(mab.order_deal_time) >= date(date('2017-08-01') - interval '1' year)
    GROUP BY province, order_channel, sales_mode, store_type, store_level, channel_type, all
) lyst
ON matl.province = lyst.province
AND matl.order_channel = lyst.order_channel
AND matl.sales_mode = lyst.sales_mode
AND matl.store_type = lyst.store_type
AND matl.store_level = lyst.store_level
AND matl.channel_type = lyst.channel_type
AND matl.all = lyst.all

WHERE matl.province IN ('广东省')
AND matl.order_channel IN('线下')
AND matl.sales_mode IN ('ZJ')
AND matl.store_type IN ('MALL')
AND matl.store_level IN ('A')
AND matl.channel_type IN ('自营')

UNION

SELECT DISTINCT
    matl2.member_type,
    -- 销售收入(万元)
    cast(IF(sm2.si IS NOT NULL, sm2.si, 0) AS DECIMAL(10, 3))  AS sales_income,
    -- 销售收入占比(%)
    cast(IF(IF(smtt.ttsi IS NOT NULL, smtt.ttsi, 0) != 0, IF(sm2.si IS NOT NULL, sm2.si, 0) * 100.00 / IF(smtt.ttsi IS NOT NULL, smtt.ttsi, 0), 0) AS DECIMAL(10, 2)) AS sales_income_proportion,
    -- 消费人数
    cast(IF(sm2.ca IS NOT NULL, sm2.ca, 0) AS INTEGER) AS customer_amount,
    -- 交易单数
    cast(IF(sm2.oa IS NOT NULL, sm2.oa, 0) AS INTEGER) AS order_amount,
    -- 消费频次
    cast(IF(IF(sm2.ca IS NOT NULL, sm2.ca, 0) != 0, IF(sm2.oa IS NOT NULL, sm2.oa, 0) / IF(sm2.ca IS NOT NULL, sm2.ca, 0), 0) AS INTEGER) AS consumption_frequency,
    -- 客单价
    cast(IF(IF(sm2.oa IS NOT NULL, sm2.oa, 0) != 0, IF(sm2.si IS NOT NULL, sm2.si, 0) * 10000.0 / IF(sm2.oa IS NOT NULL, sm2.oa, 0), 0) AS DECIMAL(10, 2)) AS sales_income_per_order,
    -- 件单价
    cast(IF(IF(sm2.siq IS NOT NULL, sm2.siq, 0) != 0, IF(sm2.si IS NOT NULL, sm2.si, 0) * 10000.0 / IF(sm2.siq IS NOT NULL, sm2.siq, 0), 0) AS DECIMAL(10, 2)) AS sales_income_per_item,
    -- 客单件
    cast(IF(IF(sm2.oa IS NOT NULL, sm2.oa, 0) != 0, IF(sm2.siq IS NOT NULL, sm2.siq, 0) / IF(sm2.oa IS NOT NULL, sm2.oa, 0), 0) AS INTEGER) AS sales_item_per_order,
    -- 同比
    cast(IF(IF(lyst2.si IS NOT NULL, lyst2.si, 0) != 0, (IF(sm2.si IS NOT NULL, sm2.si, 0) - IF(lyst2.si IS NOT NULL, lyst2.si, 0)) * 100.0 / IF(lyst2.si IS NOT NULL, lyst2.si, 0), 0) AS DECIMAL(10, 2)) AS sales_income_growth
FROM (
    SELECT DISTINCT
        province, order_channel, sales_mode, store_type, store_level, channel_type, member_type
    FROM cdm_crm.member_analyse_type_label
) matl2

LEFT JOIN (
    SELECT province, order_channel, sales_mode, store_type, store_level, channel_type, member_type,
    sum(mab.order_fact_amount) * 1.0 / 10000                  AS si,
    IF(member_type = '会员', count(distinct member_no), NULL)  AS ca,
    count(distinct mab.outer_order_no)                        AS oa,
    sum(mab.order_item_quantity)                              AS siq
    FROM cdm_crm.member_analyse_base mab
    WHERE date(mab.order_deal_time) <= date('2018-08-01')
    AND date(mab.order_deal_time) >= date('2017-08-01')
    GROUP BY province, order_channel, sales_mode, store_type, store_level, channel_type, member_type
) sm2
ON matl2.province = sm2.province
AND matl2.order_channel = sm2.order_channel
AND matl2.sales_mode = sm2.sales_mode
AND matl2.store_type = sm2.store_type
AND matl2.store_level = sm2.store_level
AND matl2.channel_type = sm2.channel_type
AND matl2.member_type = sm2.member_type

LEFT JOIN (
    SELECT province, order_channel, sales_mode, store_type, store_level, channel_type,
    sum(mab.order_fact_amount) *1.0 / 10000 AS ttsi
    FROM cdm_crm.member_analyse_base mab
    WHERE date(mab.order_deal_time) <= date('2018-08-01')
    AND date(mab.order_deal_time) >= date('2017-08-01')
    GROUP BY province, order_channel, sales_mode, store_type, store_level, channel_type
) smtt
ON matl2.province = smtt.province
AND matl2.order_channel = smtt.order_channel
AND matl2.sales_mode = smtt.sales_mode
AND matl2.store_type = smtt.store_type
AND matl2.store_level = smtt.store_level
AND matl2.channel_type = smtt.channel_type

LEFT JOIN (
    SELECT province, order_channel, sales_mode, store_type, store_level, channel_type, member_type,
    sum(mab.order_fact_amount) * 1.0 / 10000  AS si
    FROM cdm_crm.member_analyse_base mab
    WHERE date(mab.order_deal_time) <= date(date('2018-08-01') - interval '1' year)
    AND date(mab.order_deal_time) >= date(date('2017-08-01') - interval '1' year)
    GROUP BY province, order_channel, sales_mode, store_type, store_level, channel_type, member_type
) lyst2
ON matl2.province = lyst2.province
AND matl2.order_channel = lyst2.order_channel
AND matl2.sales_mode = lyst2.sales_mode
AND matl2.store_type = lyst2.store_type
AND matl2.store_level = lyst2.store_level
AND matl2.channel_type = lyst2.channel_type
AND matl2.member_type = lyst2.member_type

WHERE matl2.province IN ('广东省')
AND matl2.order_channel IN ('线下')
AND matl2.sales_mode IN ('ZJ')
AND matl2.store_type IN ('MALL')
AND matl2.store_level IN ('A')
AND matl2.channel_type IN ('自营');
