WITH
  --横维度：R 纵维度：M 的mapping表
    duration_dimension_map AS (
      SELECT *
      FROM
        rfm_duration_dimension_map
      WHERE horizontal = 'R' AND vertical = 'M'
      ORDER BY duration, h_greater_than, v_not_less_than
  ),
  --横、纵维度mapping结果转换成json对象
    rfm_json_temp AS (
      SELECT
        'where_conditions',
        json_format(
            cast(
                MAP(
                    ARRAY ['computing_duration', 'h_id', 'v_id', 'h_greater_than', 'h_not_greater_than', 'v_greater_than', 'v_not_greater_than'],
                    ARRAY [
                    IF(duration_dimension_map.duration IS NULL, '-', CAST(duration_dimension_map.duration AS VARCHAR)),
                    IF(duration_dimension_map.h_id IS NULL, '-', CAST(duration_dimension_map.h_id AS VARCHAR)),
                    IF(duration_dimension_map.v_id IS NULL, '-', CAST(duration_dimension_map.v_id AS VARCHAR)),
                    IF(duration_dimension_map.h_greater_than IS NULL, '-', CAST(duration_dimension_map.h_greater_than AS VARCHAR)),
                    IF(duration_dimension_map.h_not_greater_than IS NULL, '-', CAST(duration_dimension_map.h_not_greater_than AS VARCHAR)),
                    IF(duration_dimension_map.v_greater_than IS NULL, '-', CAST(duration_dimension_map.v_greater_than AS VARCHAR)),
                    IF(duration_dimension_map.v_not_greater_than IS NULL, '-', CAST(duration_dimension_map.v_not_greater_than AS VARCHAR))
                    ]
                ) AS JSON
            )
        ) AS condition_val
      FROM duration_dimension_map
  )
SELECT
  'rfm_json',
  array_join(ARRAY_AGG(rfm_json_temp.condition_val), '~')
FROM rfm_json_temp;






















