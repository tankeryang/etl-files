INSERT INTO ods_crm.order_item
    SELECT
        cast(order_item_no AS VARCHAR),
        cast(order_from AS INTEGER),
        order_id,
        cast(outer_order_no AS VARCHAR),
        cast(clerk_no AS VARCHAR),
        cast(item_type AS VARCHAR),
        original_order_id,
        cast(product_item_code AS VARCHAR),
        cast(product_code AS VARCHAR),
        cast(product_color_code AS VARCHAR),
        cast(product_size_code AS VARCHAR),
        quantity,
        cast(total_amount AS DECIMAL(38, 2)),
        cast(fact_amount AS DECIMAL(38, 2)),
        cast(discount_rate AS DECIMAL(38, 2)),
        cast(currency AS VARCHAR),
        cast(discount_type AS VARCHAR),
        cast(item_status AS VARCHAR),
        return_quantity,
        cast(return_amount AS DECIMAL(38, 2)),
        cast(sub_coupon_amount AS DECIMAL(38, 2)),
        localtimestamp
    FROM prod_mysql_crm.crm.order_item
    WHERE
        date_format(create_time, '%Y-%m-%d %T') > (
        SELECT date_format(max(create_time), '%Y-%m-%d %T')
        FROM ods_crm.order_item
        )
        AND date_format(create_time, '%Y-%m-%d %T') <= date_format(localtimestamp, '%Y-%m-%d %T');
