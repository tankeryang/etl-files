DELETE FROM cdm_crm.rfm_base_with_expression;


INSERT INTO cdm_crm.rfm_base_with_expression (
    horizon_type,
    horizon_expression,
    horizon_type_range,
    rfm_base_id,
    rfm_conf_dimension_first,
    rfm_conf_dimension_second,
    computing_duration,
    computing_until_month,
    member_count,
    order_count,
    member_spent,
    create_time,
    vertical_type,
    vertical_expression,
    vertical_type_range
    )
    WITH
        rfm_base_temp1 AS (
            SELECT
            rf.type                 AS horizon_type,
            rf.condition_expression AS horizon_expression,
            CASE WHEN rf.type = 'R' AND rb.rfm_conf_dimension_first > 0
                THEN CAST(rf.greater_than AS VARCHAR) || ',' || CAST(rf.not_greater_than AS VARCHAR)
            WHEN rf.type = 'F' AND rb.rfm_conf_dimension_first > 0
                THEN CAST(rf.not_less_than AS VARCHAR) || ',' || CAST(rf.less_than AS VARCHAR)
            WHEN rf.type = 'M' AND rb.rfm_conf_dimension_first > 0
                THEN CAST(rf.greater_than AS VARCHAR) || ',' || CAST(rf.not_greater_than AS VARCHAR)
            WHEN rf.type = 'G' AND rb.rfm_conf_dimension_first > 0
                THEN CAST(rf.rfm_conf_id AS VARCHAR)
            ELSE NULL END           AS horizon_type_range,
            rb.*
            FROM cdm_crm.rfm_base rb
            LEFT JOIN prod_mysql_crm.crm.rfm_conf rf
                ON rb.rfm_conf_dimension_first = rf.rfm_conf_id AND rf.status = 1
        ),
        rfm_base_temp2 AS (
            SELECT
            rf.type                 AS vertical_type,
            rf.condition_expression AS vertical_expression,
            CASE WHEN rf.type = 'R' AND rb.rfm_conf_dimension_second > 0
                THEN CAST(rf.greater_than AS VARCHAR) || ',' || CAST(rf.not_greater_than AS VARCHAR)
            WHEN rf.type = 'F' AND rb.rfm_conf_dimension_second > 0
                THEN CAST(rf.not_less_than AS VARCHAR) || ',' || CAST(rf.less_than AS VARCHAR)
            WHEN rf.type = 'M' AND rb.rfm_conf_dimension_second > 0
                THEN CAST(rf.greater_than AS VARCHAR) || ',' || CAST(rf.not_greater_than AS VARCHAR)
            WHEN rf.type = 'G' AND rb.rfm_conf_dimension_second > 0
                THEN CAST(rf.rfm_conf_id AS VARCHAR)
            ELSE NULL END           AS vertical_type_range,
            rb.*
            FROM cdm_crm.rfm_base rb
            LEFT JOIN prod_mysql_crm.crm.rfm_conf rf
                ON rb.rfm_conf_dimension_second = rf.rfm_conf_id AND rf.status = 1
        ),
        --带横维度、纵维度的condition_expression的rfm_base
        rfm_base_temp3 AS (
            SELECT
            rfm_base_temp1.*,
            rfm_base_temp2.vertical_type,
            rfm_base_temp2.vertical_expression,
            rfm_base_temp2.vertical_type_range
            FROM rfm_base_temp1, rfm_base_temp2
            WHERE rfm_base_temp1.rfm_conf_dimension_first = rfm_base_temp2.rfm_conf_dimension_first
                AND rfm_base_temp1.rfm_conf_dimension_second = rfm_base_temp2.rfm_conf_dimension_second
                AND rfm_base_temp1.computing_duration = rfm_base_temp2.computing_duration
                AND rfm_base_temp1.computing_until_month = rfm_base_temp2.computing_until_month
            -- AND (t1.type = 'R' AND t2.type = 'F')
            -- OR (t1.type = 'R' AND t2.type IS NULL ) OR (t1.type IS NULL AND t2.type = 'F')
            ORDER BY rfm_base_temp1.computing_until_month, rfm_base_temp1.computing_duration,
            rfm_base_temp1.rfm_conf_dimension_first,
            rfm_base_temp2.rfm_conf_dimension_second
        )
    SELECT
        horizon_type,
        horizon_expression,
        horizon_type_range,
        rfm_base_id,
        rfm_conf_dimension_first,
        rfm_conf_dimension_second,
        computing_duration,
        computing_until_month,
        member_count,
        order_count,
        member_spent,
        LOCALTIMESTAMP AS create_time,
        vertical_type,
        vertical_expression,
        vertical_type_range
    FROM rfm_base_temp3;