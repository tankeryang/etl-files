DROP TABLE IF EXISTS cdm_crm.daliy_report_store_day_base;


CREATE TABLE IF NOT EXISTS cdm_crm.daliy_report_store_day_base (
    country                             VARCHAR         COMMENT '全国',
    sales_area                          VARCHAR         COMMENT '区域',
    city                                VARCHAR         COMMENT '城市',
    store_code                          VARCHAR         COMMENT '门店',
    member_type                         VARCHAR         COMMENT '客户类型',
    sales_amount                        DECIMAL(38, 2)  COMMENT '销售金额',
    retail_amount                       DECIMAL(38, 2)  COMMENT '吊牌金额',
    order_amount                        INTEGER         COMMENT '单数',
    total_sales_amount                  DECIMAL(18, 2)  COMMENT '总销售金额',
    member_total_sales_amount           DECIMAL(18, 2)  COMMENT '会员总销售金额',
    sales_amount_proportion_total       DECIMAL(18, 4)  COMMENT '销售金额占比汇总',
    last_year_same_time_sales_amount    DECIMAL(38, 2)  COMMENT '去年同期销售金额',
    sales_item_quantity                 INTEGER         COMMENT '销售件数',
    member_amount                       INTEGER         COMMENT '消费会员',
    past_12_month_remain_member_amount  INTEGER         COMMENT '上月存量',
    new_vip_member_amount               INTEGER         COMMENT '会员招募-VIP',
    new_normal_member_amount            INTEGER         COMMENT '会员招募-普通会员',
    upgraded_member_amount              INTEGER         COMMENT '会员升级',
    store_amount                        INTEGER         COMMENT '店铺数',
    member_amount_per_store             DECIMAL(18, 2)  COMMENT '店均消费总数',
    order_deal_date                     DATE            COMMENT '订单日期'
);