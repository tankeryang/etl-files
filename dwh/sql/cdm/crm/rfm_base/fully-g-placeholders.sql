WITH
    --横维度：G 纵维度：0/不限 的mapping表
        duration_rfm_conf_temp AS (
        SELECT *
        FROM
            duration_rfm_conf
        WHERE type = 'G'
        ORDER BY duration, equals
    ),
    --横、纵维度mapping结果转换成json对象
        rfm_json_temp AS (
        SELECT
            'where_conditions',
            json_format(
                cast(
                    MAP(
                        ARRAY ['computing_duration', 'rfm_conf_id', 'not_less_than', 'not_greater_than'],
                        ARRAY [
                        CAST(duration AS VARCHAR),
                        IF(rfm_conf_id IS NULL, '-', CAST(rfm_conf_id AS VARCHAR)),
                        IF(not_less_than IS NULL, '-', CAST(not_less_than AS VARCHAR)),
                        IF(not_greater_than IS NULL, '-', CAST(not_greater_than AS VARCHAR))
                        ]
                    ) AS JSON
                )
            ) AS condition_val
        FROM duration_rfm_conf_temp
    )
    SELECT
        ARRAY_AGG(rfm_json_temp.condition_val) AS rfm_json,
        ARRAY['2018-12-01'] AS c_date
    FROM rfm_json_temp;
