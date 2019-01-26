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
        0                                                                  AS rfm_conf_dimension_first,
        0                                                                  AS rfm_conf_dimension_second,
        CAST('{computing_duration}' AS INTEGER)                            AS computing_duration,
        DATE_FORMAT(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
        COUNT(member_no)                                                   AS member_count,
        SUM(order_count)                                                   AS order_count,
        SUM(monetary_total)                                                AS member_spent,
        localtimestamp                                                     AS create_time
    FROM cdm_crm.member_rfm
    WHERE computing_duration = CAST('{computing_duration}' AS INTEGER);