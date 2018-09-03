INSERT INTO ods_crm.member_grade_log
    SELECT
        log_id                    AS log_id,
        member_no                 AS member_no,
        before_grade_id           AS before_grade_id,
        after_grade_id            AS current_grade_id,
        grade_change_time         AS grade_change_time,
        localtimestamp            AS create_time
    FROM
        prod_mysql_crm.crm.member_grade_log
    WHERE
        date_format(grade_change_time, '%Y-%m-%d %T') > (
            SELECT date_format(max(create_time), '%Y-%m-%d %T')
            FROM ods_crm.member_grade_log
        )
        AND date_format(grade_change_time, '%Y-%m-%d %T') <= date_format(localtimestamp, '%Y-%m-%d %T');