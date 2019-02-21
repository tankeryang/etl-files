CREATE SCHEMA IF NOT EXISTS ads_crm;


DROP TABLE IF EXISTS ads_crm.member_grouping_info_detail;


CREATE TABLE IF NOT EXISTS ads_crm.member_grouping_info_detail (
    -- 会员基本信息
    member_no                             VARCHAR        COMMENT '会员编号',
    brand_code                            VARCHAR        COMMENT '品牌编号',
    member_birthday                       VARCHAR        COMMENT '会员生日(月/日)',
    member_birthday_month                 VARCHAR        COMMENT '会员生日月份',
    member_gender                         VARCHAR        COMMENT '会员性别',
    member_age                            INTEGER        COMMENT '会员年龄',
    member_status                         VARCHAR        COMMENT '会员状态(正常/作废/异常卡)',
    member_register_date                  DATE           COMMENT '会员注册时间',
    member_manage_store                   VARCHAR        COMMENT '会员管理门店',
    member_register_store                 VARCHAR        COMMENT '会员注册门店',
    member_reg_source                     VARCHAR        COMMENT '会员注册渠道',
    member_is_batch_mobile                INTEGER        COMMENT '会员是否绑定手机(1:是/0:否)',
    member_is_batch_wechat                INTEGER        COMMENT '会员是否绑定微信(1:是/0:否)',
    member_is_batch_taobao                INTEGER        COMMENT '会员是否绑定淘宝(1:是/0:否)',
    member_grade_id                       INTEGER        COMMENT '会员等级',
    member_grade_expiration_date          DATE           COMMENT '会员等级到期日期',
    member_score                          DECIMAL(11, 2) COMMENT '会员积分',
    member_will_score                     DECIMAL(11, 2) COMMENT '会员未到账积分',
    -- 最近消费
    lst_consumption_date                  DATE           COMMENT '最近消费日期',
    lst_consumption_gap                   INTEGER        COMMENT '最近消费间隙(最近一次消费时间距离今天的间隔天数)',
    lst_consumption_store                 VARCHAR        COMMENT '最近消费门店',
    lst_consumption_item_quantity         INTEGER        COMMENT '最近消费件数',
    lst_consumption_amount                DECIMAL(18, 2) COMMENT '最近消费金额',
    lst_consumption_amount_include_coupon DECIMAL(18, 2) COMMENT '最近消费金额',
    -- 首次消费
    fst_consumption_date                  DATE           COMMENT '首次消费日期',
    fst_consumption_gap                   INTEGER        COMMENT '首次消费间隙(最近一次消费时间距离今天的间隔天数)',
    fst_consumption_store                 VARCHAR        COMMENT '首次消费门店',
    fst_consumption_item_quantity         INTEGER        COMMENT '首次消费件数',
    fst_consumption_amount                DECIMAL(18, 2) COMMENT '首次消费金额',
    fst_consumption_amount_include_coupon DECIMAL(18, 2) COMMENT '首次消费金额',
    -- 累计消费
    -- cml_consumption_store                 VARCHAR        COMMENT '累计消费门店',
    -- cml_consumption_order_no              VARCHAR        COMMENT '累计消费单号',
    -- cml_consumption_item_quantity         INTEGER        COMMENT '累计消费件数',
    -- cml_retail_amount                     DECIMAL(18, 2) COMMENT '累计吊牌金额',
    -- cml_consumption_amount                DECIMAL(18, 2) COMMENT '累计消费金额',
    -- cml_consumption_amount_include_coupon DECIMAL(18, 2) COMMENT '累计消费金额(含券)',
    -- cml_return_order_no                   VARCHAR        COMMENT '累计退款单号',
    -- cml_return_amount                     DECIMAL(18, 2) COMMENT '累计退款金额',
    -- cml_consumption_date                  DATE           COMMENT '累计消费日期',
    -- cml_consumption_year_month            VARCHAR        COMMENT '累计消费年-月',
    create_time                           TIMESTAMP
) WITH (format = 'ORC');
