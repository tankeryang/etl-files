WITH
        t0 AS ( SELECT
                1 AS join_key,
                1 AS computing_duration
                UNION ALL
                SELECT
                1 AS join_key,
                2 AS computing_duration
    ),
        t1 AS (
        SELECT
            1 AS join_key,
            t.*
        FROM dev_mysql_fpsit.crm.rfmc_conf t
    ),
        t2 AS (
        SELECT
            1 AS join_key,
            t.*
        FROM dev_mysql_fpsit.crm.rfmc_conf t
    ),
        t3 AS (
        SELECT
            t0.computing_duration   AS computing_duration,
            t1.type                 AS horizontal,
            t2.type                 AS vertical,
            t1.rfmc_conf_id         AS h_id,
            t2.rfmc_conf_id         AS v_id,
            t1.greater_than         AS h_greater_than,
            t1.not_greater_than     AS h_not_greater_than,
            t1.equals               AS h_equals,
            t1.not_less_than        AS h_not_less_than,
            t1.condition_expression AS h_condition_expression,
            t2.condition_expression AS v_condition_expression,
            t2.greater_than         AS v_greater_than,
            t2.not_greater_than     AS v_not_greater_than,
            t2.equals               AS v_equals,
            t2.not_less_than        AS v_not_less_than
        FROM
            t0
            LEFT JOIN t1
            ON t0.join_key = t1.join_key
            LEFT JOIN
            t2
            ON t1.join_key = t2.join_key
                AND t1.type <> t2.type
    ),
        t4 AS (
        SELECT *
        FROM
            t3
        WHERE t3.horizontal = 'R' AND t3.vertical = 'F'
        --      AND t3.h_not_greater_than IS NOT NULL
        --      AND t3.v_equals IS NOT NULL
        ORDER BY t3.computing_duration, t3.h_greater_than, t3.v_condition_expression

    )
    --select * from t4;
    ,
        t5 AS (
        SELECT
            'where_conditions',
            json_format(
                cast(
                    MAP(
                        ARRAY ['computing_duration', 'h_id', 'v_id', 'h_greater_than', 'h_not_greater_than', 'v_equals', 'v_not_less_than', 'v_not_greater_than'],
                        ARRAY [
                        IF(t4.computing_duration IS NULL, '-', CAST(t4.computing_duration AS VARCHAR)),
                        IF(t4.h_id IS NULL, '-', CAST(t4.h_id AS VARCHAR)),
                        IF(t4.v_id IS NULL, '-', CAST(t4.v_id AS VARCHAR)),
                        IF(t4.h_greater_than IS NULL, '-', CAST(t4.h_greater_than AS VARCHAR)),
                        IF(t4.h_not_greater_than IS NULL, '-', CAST(t4.h_not_greater_than AS VARCHAR)),
                        IF(t4.v_equals IS NULL, '-', CAST(t4.v_equals AS VARCHAR)),
                        IF(t4.v_not_less_than IS NULL, '-', CAST(t4.v_not_less_than AS VARCHAR)),
                        IF(t4.v_not_greater_than IS NULL, '-', CAST(t4.v_not_greater_than AS VARCHAR))
                        ]
                    ) AS JSON
                )
            ) AS condition_val
        FROM t4
    )
    select * from t5;
    SELECT
    'rfmc_json',
    array_join(ARRAY_AGG(t5.condition_val), '~')
    FROM t5;
