INSERT INTO cdm_crm.order_item_detail
    SELECT
        oif.brand_code,
        oif.member_no,
        oit.outer_order_no,
        oit.item_type,
        oit.product_item_code,
        oit.product_code,
        oit.product_color_code,
        oit.product_size_code,
        ci.main_cate,
        ci.sub_cate,
        ci.leaf_cate,
        ci.lining,
        oit.quantity,
        cast(oit.total_amount AS DECIMAL(18, 2)),
        cast(oit.fact_amount AS DECIMAL(18, 2)),
        cast(oit.discount_rate AS DECIMAL(18, 2)),
        oif.order_deal_time,
        localtimestamp
    FROM ods_crm.order_item oit
    LEFT JOIN ods_crm.order_info oif ON oit.outer_order_no = oif.outer_order_no
    LEFT JOIN ods_crm.commodity_info ci ON oit.product_code = ci.product_code
    WHERE date_format(oif.order_deal_time, '%Y-%m-%d %T') > (
        SELECT max(date_format(order_deal_time, '%Y-%m-%d %T')) FROM cdm_crm.order_item_detail
    )
    AND date(oif.order_deal_time) < date(localtimestamp);