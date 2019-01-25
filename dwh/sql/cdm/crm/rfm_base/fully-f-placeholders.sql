WITH
    --横维度：F 纵维度：0 的mapping表
        duration_rfm_conf_temp AS (
        SELECT *
        FROM
            duration_rfm_conf
        WHERE type = 'F'
        ORDER BY duration, not_less_than
    ),
        rfm_json_temp AS (
        SELECT
            'where_conditions',
            json_format(
                cast(
                    MAP(
                        ARRAY ['computing_duration', 'rfm_conf_id', 'not_less_than', 'less_than'],
                        ARRAY [
                        IF(duration IS NULL, '-', CAST(duration AS VARCHAR)),
                        IF(rfm_conf_id IS NULL, '-', CAST(rfm_conf_id AS VARCHAR)),
                        IF(not_less_than IS NULL, '-', CAST(not_less_than AS VARCHAR)),
                        IF(less_than IS NULL, '-', CAST(less_than AS VARCHAR))
                        ]
                    ) AS JSON
                )
            ) AS condition_val
        FROM duration_rfm_conf_temp
    )
    SELECT
        ARRAY_AGG(rfm_json_temp.condition_val) AS rfm_json,
        ARRAY[current_date] AS c_date
    FROM rfm_json_temp;
