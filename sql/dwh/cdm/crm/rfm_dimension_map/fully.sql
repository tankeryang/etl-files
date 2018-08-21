INSERT INTO rfm_dimension_map (
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
    --构造rfm_conf临时表给横、纵维度做关联
      rfm_conf_temp1 AS (
        SELECT
          1 AS join_key,
          t.*
        FROM prod_mysql_crm.crm.rfm_conf t
        WHERE STATUS = 1
    ),
      rfm_conf_temp2 AS (
        SELECT
          1 AS join_key,
          t.*
        FROM prod_mysql_crm.crm.rfm_conf t
        WHERE STATUS = 1
    ),
      t_rfm_dimension_map AS (
        SELECT
          rfm_conf_temp1.type                 AS horizontal,
          rfm_conf_temp2.type                 AS vertical,
          rfm_conf_temp1.rfm_conf_id          AS h_id,
          rfm_conf_temp2.rfm_conf_id          AS v_id,
          rfm_conf_temp1.greater_than         AS h_greater_than,
          rfm_conf_temp1.not_greater_than     AS h_not_greater_than,
          rfm_conf_temp1.equals               AS h_equals,
          rfm_conf_temp1.not_less_than        AS h_not_less_than,
          rfm_conf_temp1.less_than            AS h_less_than,
          rfm_conf_temp1.condition_expression AS h_condition_expression,
          rfm_conf_temp2.condition_expression AS v_condition_expression,
          rfm_conf_temp2.greater_than         AS v_greater_than,
          rfm_conf_temp2.not_greater_than     AS v_not_greater_than,
          rfm_conf_temp2.equals               AS v_equals,
          rfm_conf_temp2.not_less_than        AS v_not_less_than,
          rfm_conf_temp2.less_than            AS v_less_than
        FROM
          rfm_conf_temp1
          LEFT JOIN
          rfm_conf_temp2
            ON rfm_conf_temp1.join_key = rfm_conf_temp2.join_key
               AND rfm_conf_temp1.type <> rfm_conf_temp2.type
    )
  SELECT *
  FROM t_rfm_dimension_map;