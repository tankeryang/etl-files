INSERT INTO duration_rfm_conf (
  duration,
  type,
  rfm_conf_id,
  greater_than,
  not_greater_than,
  equals,
  not_less_than,
  less_than,
  condition_expression
)
  WITH
      rfm_duration_temp AS (
        SELECT
          1 AS join_key,
          t.*
        FROM rfm_duration t
    ),
    --构造rfm_conf临时表做关联
      rfm_conf_temp AS (
        SELECT
          1 AS join_key,
          t.*
        FROM prod_mysql_crm.crm.rfm_conf t
        WHERE STATUS = 1
    )
  SELECT
    rfm_duration_temp.duration,
    rfm_conf_temp.type,
    rfm_conf_temp.rfm_conf_id,
    rfm_conf_temp.greater_than,
    rfm_conf_temp.not_greater_than,
    rfm_conf_temp.equals,
    rfm_conf_temp.not_less_than,
    rfm_conf_temp.less_than,
    rfm_conf_temp.condition_expression
  FROM rfm_duration_temp
    LEFT JOIN rfm_conf_temp
      ON rfm_duration_temp.join_key = rfm_conf_temp.join_key;