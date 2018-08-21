INSERT INTO member_structure_duration_order_store (
  computing_until_month,
  computing_duration,
  order_id,
  order_fact_amount,
  order_deal_time,
  member_no,
  grade_id,
  grade_code,
  channel_type,
  sales_area,
  store_region
)
  WITH
--     --订单范围
--       order_info_range AS (
--         SELECT *
--         FROM member_structure_order_info_range
--         WHERE computing_until_month = date_format(CURRENT_DATE + INTERVAL '-1' MONTH, '%Y-%m')
--               AND computing_duration = CAST('{computing_duration}' AS INTEGER)
--     ),
    --订单(正价、退换货并购买等）
      order_info AS (
        SELECT *
        FROM member_structure_order_info
        WHERE computing_until_month = date_format(CURRENT_DATE + INTERVAL '-1' MONTH, '%Y-%m')
              AND computing_duration = CAST('{computing_duration}' AS INTEGER)
    ),
    --扣减现金券后的订单金额
      order_sub_coupon_amount AS (
        SELECT
          oi.order_id,
          sum(CASE WHEN oit.sub_coupon_amount IS NOT NULL
            THEN oit.sub_coupon_amount
              ELSE oit.fact_amount END) AS total_sub_coupon_amount

        FROM order_info oi, ods_crm.order_item oit
        WHERE oi.order_id = oit.order_id
        GROUP BY oi.order_id
    )
  SELECT
    date_format(CURRENT_DATE + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
    CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
    oi.order_id,
    osca.total_sub_coupon_amount                               AS order_fact_amount,
    oi.order_deal_time,
    oi.member_no,
    oi.order_grade                                           AS grade_id,
    mgi.grade_code,
    si.channel_type,
    si.sales_area,
    si.city                                                  AS store_region
  FROM order_info oi, order_sub_coupon_amount osca, ods_crm.store_info si,
    prod_mysql_crm.crm.member_grade_info mgi
  WHERE oi.order_id = osca.order_id
        AND oi.store_code = si.store_code
        AND oi.order_grade = mgi.grade_id;