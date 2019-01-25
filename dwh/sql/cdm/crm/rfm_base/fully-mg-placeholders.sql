WITH
    --横维度：M 纵维度：G 的mapping表
        duration_dimension_map AS (
        SELECT *
        FROM
            rfm_duration_dimension_map
        WHERE horizontal = 'M' AND vertical = 'G'
        ORDER BY duration, h_not_less_than, v_equals
    ),
    --横、纵维度mapping结果转换成json对象
        rfm_json_temp AS (
        SELECT
            'where_conditions',
            json_format(
                cast(
                    MAP(
                        ARRAY ['computing_duration', 'h_id', 'v_id', 'h_greater_than', 'h_not_greater_than', 'v_equals'],
                        ARRAY [
                        IF(duration_dimension_map.duration IS NULL, '-', CAST(duration_dimension_map.duration AS VARCHAR)),
                        IF(duration_dimension_map.h_id IS NULL, '-', CAST(duration_dimension_map.h_id AS VARCHAR)),
                        IF(duration_dimension_map.v_id IS NULL, '-', CAST(duration_dimension_map.v_id AS VARCHAR)),
                        IF(duration_dimension_map.h_greater_than IS NULL, '-', CAST(duration_dimension_map.h_greater_than AS VARCHAR)),
                        IF(duration_dimension_map.h_not_greater_than IS NULL, '-', CAST(duration_dimension_map.h_not_greater_than AS VARCHAR)),
                        IF(duration_dimension_map.v_equals IS NULL, '-', duration_dimension_map.v_equals)
                        ]
                    ) AS JSON
                )
            ) AS condition_val
        FROM duration_dimension_map
    )
    SELECT
        ARRAY_AGG(rfm_json_temp.condition_val) AS rfm_json,
        ARRAY['2018-12-01'] AS c_date
    FROM rfm_json_temp;
