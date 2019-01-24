DELETE FROM cdm_crm.member_structure_active_last_duration;


INSERT INTO cdm_crm.member_structure_active_last_duration (
    computing_until_month,
    computing_duration,
    last_computing_duration_end,
    last_computing_duration_time_end,
    last_computing_duration_start,
    last_computing_duration_time_start,
    double_last_computing_duration_end,
    double_last_computing_duration_time_end,
    double_last_computing_duration_start,
    double_last_computing_duration_time_start,
    triple_last_computing_duration_end,
    triple_last_computing_duration_time_end,
    triple_last_computing_duration_start,
    triple_last_computing_duration_time_start
    )
    --上(及上上、上上上、...等)月、季度、半年、年等时间区间统计表
    -----------1, 3, 6, 12个月时间段------------------------------------------------------------------------------------------------
    WITH
        active_last_duration AS (
        SELECT
            date_format(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
            duration                                                 AS computing_duration,
            duration                                                 AS last_computing_duration_end,
            date_trunc('month', date_add('month', -1 * duration,
                                        DATE('{c_date}')))              AS last_computing_duration_time_end,
            duration +
            duration                                                 AS last_computing_duration_start,
            date_trunc('month', date_add('month', -1 * (duration + duration),
                                        DATE('{c_date}')))              AS last_computing_duration_time_start,
            2 *
            duration                                                 AS double_last_computing_duration_end,
            date_trunc('month', date_add('month', -1 * (2 * duration),
                                        DATE('{c_date}')))              AS double_last_computing_duration_time_end,
            2 * duration +
            duration                                                 AS double_last_computing_duration_start,
            date_trunc('month', date_add('month', -1 * (2 * duration + duration),
                                        DATE('{c_date}')))              AS double_last_computing_duration_time_start,
            3 *
            duration                                                 AS triple_last_computing_duration_end,
            date_trunc('month', date_add('month', -1 * (3 * duration),
                                        DATE('{c_date}')))              AS triple_last_computing_duration_time_end,
            3 * duration +
            duration                                                 AS triple_last_computing_duration_start,
            date_trunc('month', date_add('month', -1 * (3 * duration + duration),
                                        DATE('{c_date}')))              AS triple_last_computing_duration_time_start
        FROM member_structure_duration
    )

    SELECT *
    FROM active_last_duration;