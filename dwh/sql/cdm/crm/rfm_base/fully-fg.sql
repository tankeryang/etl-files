INSERT INTO cdm_crm.rfm_base (
    rfm_conf_dimension_first,
    rfm_conf_dimension_second,
    computing_duration,
    computing_until_month,
    member_count,
    order_count,
    member_spent,
    create_time
    )
    SELECT
        CAST(json_extract(json_parse('{rfm_json}'), '$.h_id') AS INTEGER)               AS rfm_conf_dimension_first,
        CAST(json_extract(json_parse('{rfm_json}'), '$.v_id') AS INTEGER)               AS rfm_conf_dimension_second,
        CAST(json_extract(json_parse('{rfm_json}'), '$.computing_duration') AS INTEGER) AS computing_duration,
        DATE_FORMAT(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m')              AS computing_until_month,
        COUNT(member_no)                                                                AS member_count,
        SUM(order_count)                                                                AS order_count,
        SUM(monetary_total)                                                             AS member_spent,
        localtimestamp                                                                  AS create_time
    FROM cdm_crm.member_rfm
    WHERE frequency >= CAST(json_extract(json_parse('{rfm_json}'), '$.h_not_less_than') AS BIGINT)
            AND frequency < CAST(json_extract(json_parse('{rfm_json}'), '$.h_less_than') AS BIGINT)
            AND grade_code = CAST(json_extract(json_parse('{rfm_json}'), '$.v_equals') AS VARCHAR)
            AND computing_duration = CAST(json_extract(json_parse('{rfm_json}'), '$.computing_duration') AS INTEGER);