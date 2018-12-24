DELETE FROM cdm_crm.member_cumulative_consumption;


INSERT INTO cdm_crm.member_cumulative_consumption
    SELECT
        oif.member_no,
        oif.brand_code,
        oif.store_code,
        IF(oit.item_type = 'SALE', oit.product_item_code, NULL) AS consumption_sku,
        CAST(IF(oif.order_type_num = 1, oif.outer_order_no, NULL) AS VARCHAR) AS consumption_order_no,
        CAST(IF(oif.order_type_num = 1, oit.total_amount, 0) AS DECIMAL(18, 2)) AS retail_amount,
        CAST(IF(oif.order_type_num = 1, oit.fact_amount, 0) AS DECIMAL(18, 2)) AS consumption_amount,
        CAST(IF(oif.order_type_num = 1, oif.order_fact_amount_include_coupon, 0) AS DECIMAL(18, 2)) AS consumption_amount_include_coupon,
        CAST(IF(oif.order_type_num = -1, oif.outer_order_no, NULL) AS VARCHAR) AS return_order_no,
        CAST(IF(oif.order_type_num = -1, oif.order_fact_amount, 0) AS DECIMAL(18, 2)) AS return_amount,
        CAST(oif.order_item_quantity AS INTEGER) AS consumption_item_quantity,
        oif.order_deal_date AS consumption_date,
        oif.order_deal_time AS consumption_time,
        localtimestamp
    FROM cdm_crm.order_info_detail oif
    LEFT JOIN cdm_crm.order_item_detail oit
    ON oif.member_no = oit.member_no
        AND oif.brand_code = oit.brand_code
        AND oif.outer_order_no = oit.outer_order_no
    WHERE CAST(oif.member_no AS INTEGER) > 0;
