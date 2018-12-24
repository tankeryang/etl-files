DELETE FROM cdm_crm.member_last_consumption;


INSERT INTO cdm_crm.member_last_consumption
    WITH mlt AS (
        SELECT
            member_no,
            brand_code,
            store_code,
            MAX(order_deal_date) AS order_deal_date
        FROM cdm_crm.order_info_detail
        WHERE CAST(member_no AS INTEGER) > 0
        GROUP BY member_no, brand_code, store_code
    )
    SELECT DISTINCT
        mlt.member_no,
        mlt.brand_code,
        mlt.store_code,
        CAST(SUM(oi.order_fact_amount) AS DECIMAL(18, 2)) AS consumption_amount,
        CAST(SUM(oi.order_fact_amount_include_coupon) AS DECIMAL(18, 2)) AS consumption_amount_include_coupon,
        CAST(SUM(oi.order_item_quantity) AS INTEGER) AS consumption_item_quantity,
        mlt.order_deal_date AS consumption_date,
        CAST(date_diff('day', mlt.order_deal_date, localtimestamp) AS INTEGER) AS consumption_gap,
        localtimestamp
    FROM mlt LEFT JOIN cdm_crm.order_info_detail oi
    ON mlt.member_no = oi.member_no
        AND mlt.brand_code = oi.brand_code
        AND mlt.order_deal_date = oi.order_deal_date
        AND mlt.store_code = oi.store_code
    GROUP BY mlt.member_no, mlt.brand_code, mlt.store_code, mlt.order_deal_date;
