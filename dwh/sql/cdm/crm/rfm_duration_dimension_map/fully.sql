DELETE FROM cdm_crm.rfm_duration_dimension_map;


INSERT INTO cdm_crm.rfm_duration_dimension_map (
    duration,
    horizontal,
    vertical,
    h_id,
    v_id,
    h_greater_than,
    h_not_greater_than,
    h_equals,
    h_not_less_than,
    h_less_than,
    h_condition_expression,
    v_condition_expression,
    v_greater_than,
    v_not_greater_than,
    v_equals,
    v_not_less_than,
    v_less_than
    )
    WITH
        rfm_duration_temp AS (
            SELECT
            1 AS join_key,
            t.*
            FROM rfm_duration t
        ),
        rfm_dimension_map_temp AS (
            SELECT
            1 AS join_key,
            t.*
            FROM rfm_dimension_map t
        )
    SELECT
        duration,
        horizontal,
        vertical,
        h_id,
        v_id,
        h_greater_than,
        h_not_greater_than,
        h_equals,
        h_not_less_than,
        h_less_than,
        h_condition_expression,
        v_condition_expression,
        v_greater_than,
        v_not_greater_than,
        v_equals,
        v_not_less_than,
        v_less_than
    FROM rfm_duration_temp
        LEFT JOIN rfm_dimension_map_temp
        ON rfm_duration_temp.join_key = rfm_dimension_map_temp.join_key;