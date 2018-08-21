INSERT INTO rfmc_base (
  rfmc_conf_dimension_first,
  rfmc_conf_dimension_second,
  computing_duration,
  computing_until_date,
  member_count,
  order_count,
  member_spent,
  create_time
)
  SELECT
    cast(json_extract(json_parse('{rfmc_json}'), '$.h_id') AS INTEGER)               AS rfmc_conf_dimension_first,
    cast(json_extract(json_parse('{rfmc_json}'), '$.v_id') AS INTEGER)               AS rfmc_conf_dimension_second,
    cast(json_extract(json_parse('{rfmc_json}'), '$.computing_duration') AS INTEGER) AS computing_duration,
    current_date                                                                     AS computing_until_date,
    sum(user_id)                                                                     AS total_member_count,
    sum(order_quantity)                                                              AS order_count,
    sum(monetary_total)                                                              AS member_spent,
    localtimestamp                                                                   AS create_time
  FROM user_rfmc
  WHERE computing_duration = cast(json_extract(json_parse('{rfmc_json}'), '$.computing_duration') AS INTEGER)
        AND recency > cast(json_extract(json_parse('{rfmc_json}'), '$.h_greater_than') AS BIGINT)
        AND recency <= cast(json_extract(json_parse('{rfmc_json}'), '$.h_not_greater_than') AS BIGINT)
        AND frequency >= cast(json_extract(json_parse('{rfmc_json}'), '$.v_not_less_than') AS BIGINT)
        AND frequency <= cast(json_extract(json_parse('{rfmc_json}'), '$.v_not_greater_than') AS BIGINT);


SELECT
  t1.rfmc_conf_dimension_first,
  t2.rfmc_conf_dimension_second,
  t1.condition_expression,
  t2.condition_expression,
  t1.computing_duration,
  t1.computing_until_date,
  t1.member_count,
  t1.order_count,
  t1.member_spent,
  t1.create_time
FROM (SELECT
        cf.condition_expression,
        rb.*
      FROM rfmc_base rb, dev_mysql_fpsit.crm.rfmc_conf cf
      WHERE rb.rfmc_conf_dimension_first = cf.rfmc_conf_id) t1,
  (SELECT
     cf.condition_expression,
     rb.*
   FROM rfmc_base rb, dev_mysql_fpsit.crm.rfmc_conf cf
   WHERE rb.rfmc_conf_dimension_second = cf.rfmc_conf_id
  ) t2

WHERE t1.rfmc_conf_dimension_first = t2.rfmc_conf_dimension_first
      AND t1.rfmc_conf_dimension_second = t2.rfmc_conf_dimension_second
  and t1.computing_duration = t2.computing_duration
order by t1.computing_duration,t1.condition_expression,t2.condition_expression;