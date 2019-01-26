DELETE FROM ods_crm.order_item;


INSERT INTO ods_crm.order_item
    SELECT
        CAST(oit.order_item_no AS VARCHAR),
        CAST(oit.order_from AS INTEGER),
        oit.order_id,
        CAST(oit.outer_order_no AS VARCHAR),
        CAST(oit.clerk_no AS VARCHAR),
        CAST(oit.item_type AS VARCHAR),
        oit.original_order_id,
        CAST(oit.product_item_code AS VARCHAR),
        CAST(oit.product_code AS VARCHAR),
        CAST(oit.product_color_code AS VARCHAR),
        CAST(oit.product_size_code AS VARCHAR),
        oit.quantity,
        CAST(oit.total_amount AS DECIMAL(38, 2)),
        CAST(oit.fact_amount AS DECIMAL(38, 2)),
        CAST(oit.discount_rate AS DECIMAL(38, 2)),
        CAST(oit.currency AS VARCHAR),
        CAST(oit.discount_type AS VARCHAR),
        CAST(oit.item_status AS VARCHAR),
        oit.return_quantity,
        CAST(oit.return_amount AS DECIMAL(38, 2)),
        CAST(oit.sub_coupon_amount AS DECIMAL(38, 2)),
        oif.pay_time,
        localtimestamp
    FROM prod_mysql_crm.crm.order_item oit
    INNER JOIN prod_mysql_crm.crm.order_info oif ON oit.outer_order_no = oif.outer_order_no
    WHERE oif.pay_time < DATE_PARSE(DATE_FORMAT(localtimestamp, '%Y-%m-%d 00:00:00'), '%Y-%m-%d %T')
        AND oif.brand_code IN ('2', '3', '6');
