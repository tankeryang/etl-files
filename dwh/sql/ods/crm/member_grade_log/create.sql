CREATE SCHEMA IF NOT EXISTS ods_crm;


DROP TABLE IF EXISTS ods_crm.member_grade_log;


CREATE TABLE ods_crm.member_grade_log (
    log_id                INTEGER   COMMENT '日志id',
    brand_code            VARCHAR   COMMENT '品牌编号',
    member_no             VARCHAR   COMMENT '会员编号',
    outer_order_no        VARCHAR   COMMENT '触发等级变更的单号',
    member_grade_order_no VARCHAR   COMMENT '等级调整单',
    before_grade_id       INTEGER   COMMENT '变化前等级',
    after_grade_id        INTEGER   COMMENT '变化后等级',
    event_code            VARCHAR   COMMENT '事件编码',
    change_reason         SMALLINT  COMMENT '变化原因',
    change_reason_desc    VARCHAR   COMMENT '变化原因描述',
    store_code            VARCHAR   COMMENT '门店编号',
    clerk_no              VARCHAR   COMMENT '店员编号',
    grade_change_time     TIMESTAMP COMMENT '等级变更时间(此字段有坑, 用 create_time 暂替)',
    trigger_order_id      INTEGER   COMMENT '触发等级变更的订单id(不用)',
    grade_expiration      TIMESTAMP COMMENT '等级到期时间',
    grade_begin           TIMESTAMP COMMENT '等级开始日期',
    create_user           VARCHAR   COMMENT '创建人',
    create_time           TIMESTAMP COMMENT '创建时间',
    status                INTEGER   COMMENT '日志状态(0:无效/1:有效)'
);
