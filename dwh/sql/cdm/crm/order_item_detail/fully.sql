DELETE FROM cdm_crm.order_item_detail;


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
        -- ci.main_cate,
        -- ci.sub_cate,
        -- ci.leaf_cate,
        -- ci.lining,
        oit.quantity,
        CAST(oit.total_amount AS DECIMAL(18, 2)),
        CAST(oit.fact_amount AS DECIMAL(18, 2)),
        CAST(oit.discount_rate AS DECIMAL(18, 2)),
        oit.order_deal_time,
        localtimestamp
    FROM ods_crm.order_item oit;
