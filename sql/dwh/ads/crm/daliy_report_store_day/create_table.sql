DROP TABLE IF EXISTS ads_crm.daliy_report_store_day;


CREATE TABLE IF NOT EXISTS ads_crm.daliy_report_store_day (
    sales_area                          VARCHAR         COMMENT '区域',
    city                                VARCHAR         COMMENT '城市',
    store_code                          VARCHAR         COMMENT '门店',
    -- 销售(累计)
    member_type                         VARCHAR         COMMENT '客户类型',
    sales_amount                        DECIMAL(38, 2)  COMMENT '销售金额',
    sales_amount_proportion             DECIMAL(18, 4)  COMMENT '销售金额占比',
    sales_amount_proportion_total       DECIMAL(18, 4)  COMMENT '销售金额占比汇总',
    last_year_same_time_sales_amount    DECIMAL(38, 2)  COMMENT '去年同期销售金额',
    like_for_like_sales_growth          DECIMAL(18, 4)  COMMENT '销售同比增长',
    sales_item_quantity                 INTEGER         COMMENT '销售件数',
    discount_rate                       DECIMAL(18, 2)  COMMENT '折扣',
    -- 会员基数(累计)
    member_amount                       INTEGER         COMMENT '消费会员',
    past_12_month_remain_member_amount  INTEGER         COMMENT '上月存量',
    second_trade_rate                   DECIMAL(18, 4)  COMMENT '回头率',
    new_vip_member_amount               INTEGER         COMMENT '会员招募-VIP',
    new_normal_member_amount            INTEGER         COMMENT '会员招募-普通会员',
    upgraded_member_amount              INTEGER         COMMENT '会员升级',
    store_amount                        INTEGER         COMMENT '店铺数',
    member_amount_per_store             DECIMAL(18, 2)  COMMENT '店均消费总数',
    sales_amount_per_person             DECIMAL(18, 2)  COMMENT '人均销售金额',
    sales_item_quantity_per_person      DECIMAL(18, 2)  COMMENT '人均销售件数',
    su_per_person                       DECIMAL(18, 2)  COMMENT '人均SU',
    order_amount_per_member             DECIMAL(18, 2)  COMMENT '人均次',
    order_deal_date                     DATE            COMMENT '订单日期'
    -- create_time                         TIMESTAMP       COMMENT '记录创建日期'
);