CREATE SCHEMA IF NOT EXISTS cdm_crm;
DROP TABLE IF EXISTS cdm_crm.member_structure_active_last_duration;
--上(及上上、上上上、...等)月、季度、半年、年等时间区间统计表
CREATE TABLE member_structure_active_last_duration (
    computing_until_month                     VARCHAR,
    computing_duration                        INTEGER,
    last_computing_duration_end               INTEGER,
    last_computing_duration_time_end          DATE,
    last_computing_duration_start             INTEGER,
    last_computing_duration_time_start        DATE,
    double_last_computing_duration_end        INTEGER,
    double_last_computing_duration_time_end   DATE,
    double_last_computing_duration_start      INTEGER,
    double_last_computing_duration_time_start DATE,
    triple_last_computing_duration_end        INTEGER,
    triple_last_computing_duration_time_end   DATE,
    triple_last_computing_duration_start      INTEGER,
    triple_last_computing_duration_time_start DATE
);
