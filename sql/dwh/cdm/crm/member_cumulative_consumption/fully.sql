DELETE FROM cdm_crm.member_cumulative_consumption;


INSERT INTO cdm_crm.member_cumulative_consumption
    SELECT
        oif.member_no,
        oif.brand_code,
        oif.store_code,
        IF(oit.item_type = 'SALE',
            ARRAY_DISTINCT(ARRAY_AGG(oit.product_item_code)), ARRAY[]) AS consumption_sku_array,
        CAST(IF(
            oif.order_type_num = 1, COUNT(DISTINCT oif.outer_order_no), 0
            ) AS INTEGER)                                              AS consumption_order_amount,
        CAST(IF(
            oif.order_type_num = 1, SUM(oif.order_amount), 0
            ) AS DECIMAL(18, 2))                                       AS retail_amount,
        CAST(IF(
            oif.order_type_num = 1, SUM(oif.order_fact_amount), 0
            ) AS DECIMAL(18, 2))                                       AS consumption_amount,
        CAST(IF(
            oif.order_type_num = 1, SUM(oif.order_fact_amount_include_coupon), 0
            ) AS DECIMAL(18, 2))                                       AS consumption_amount_include_coupon,
        CAST(IF(
            oif.order_type_num = -1, COUNT(DISTINCT oif.outer_order_no), 0
            ) AS INTEGER)                                              AS return_order_amount,
        CAST(IF(
            oif.order_type_num = -1, SUM(oif.order_fact_amount), 0
            ) AS DECIMAL(18, 2))                                       AS return_amount,
        CAST(SUM(oif.order_item_quantity) AS INTEGER)                  AS consumption_item_quantity,
        oif.order_deal_date                                            AS consumption_date,
        DATE_FORMAT(oif.order_deal_date, '%Y-%m')                      AS consumption_year_month,
        localtimestamp
    FROM cdm_crm.order_info_detail oif
    LEFT JOIN cdm_crm.order_item_detail oit
    ON oif.member_no = oit.member_no
        AND oif.brand_code = oit.brand_code
        AND oif.outer_order_no = oit.outer_order_no
    WHERE CAST(oif.member_no AS INTEGER) > 0
    GROUP BY
        oif.member_no,
        oif.brand_code,
        oif.store_code,
        oit.item_type,
        oif.order_type_num,
        oif.order_deal_date;
