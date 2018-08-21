INSERT INTO rfm_base (
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
    cast(json_extract(json_parse('{rfm_json}'), '$.h_id') AS INTEGER)               AS rfm_conf_dimension_first,
    cast(json_extract(json_parse('{rfm_json}'), '$.v_id') AS INTEGER)               AS rfm_conf_dimension_second,
    cast(json_extract(json_parse('{rfm_json}'), '$.computing_duration') AS INTEGER) AS computing_duration,
    date_format(CURRENT_DATE + INTERVAL '-1' MONTH, '%Y-%m')                         AS computing_until_month,
    count(member_no)                                                                 AS member_count,
    sum(order_count)                                                                 AS order_count,
    sum(monetary_total)                                                              AS member_spent,
    localtimestamp                                                                   AS create_time
  FROM member_rfm
  WHERE recency > cast(json_extract(json_parse('{rfm_json}'), '$.h_greater_than') AS BIGINT)
        AND recency <= cast(json_extract(json_parse('{rfm_json}'), '$.h_not_greater_than') AS BIGINT)
        AND grade_code = cast(json_extract(json_parse('{rfm_json}'), '$.v_equals') AS VARCHAR)
        AND computing_duration = cast(json_extract(json_parse('{rfm_json}'), '$.computing_duration') AS INTEGER);