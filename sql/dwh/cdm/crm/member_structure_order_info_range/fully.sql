INSERT INTO cdm_crm.member_structure_order_info_range (
  computing_until_month,
  computing_duration,
  order_id,
  outer_order_no,
  store_code,
  order_deal_time,
  member_no,
  order_grade,
  order_item_quantity,
  order_amount,
  order_fact_amount,
  order_status,
  outer_return_order_no
)
-----------1, 3, 6, 12月时间段------------------------------------------------------------------------------------------------
  SELECT
    date_format(CURRENT_DATE + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
    CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
    order_id,
    outer_order_no,
    store_code,
    order_deal_time,
    member_no,
    order_grade,
    order_item_quantity,
    order_amount,
    order_fact_amount,
    order_status,
    outer_return_order_no
  FROM ods_crm.order_info
  WHERE cast(member_no AS INTEGER) > 0 AND order_deal_time IS NOT NULL AND
        order_deal_time >= date_trunc('month', CURRENT_DATE +
                                                    INTERVAL '-{computing_duration}' MONTH) AND order_deal_time < date_trunc(
            'month', CURRENT_DATE);