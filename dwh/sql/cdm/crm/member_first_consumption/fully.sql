DELETE FROM cdm_crm.member_first_consumption;


INSERT INTO cdm_crm.member_first_consumption
    WITH mft_d AS (
        SELECT
            member_no,
            brand_code,
            MIN(order_deal_date) AS order_deal_date
        FROM cdm_crm.order_info_detail
        WHERE CAST(member_no AS INTEGER) > 0
        GROUP BY member_no, brand_code
    ), mft AS (
        SELECT DISTINCT
            mft_d.member_no,
            mft_d.brand_code,
            first_value(oi_d.store_code) OVER (
                PARTITION BY mft_d.member_no, mft_d.brand_code, mft_d.order_deal_date
            ) AS store_code,
            mft_d.order_deal_date
        FROM mft_d
        LEFT JOIN cdm_crm.order_info_detail oi_d
        ON mft_d.brand_code = oi_d.brand_code
            AND mft_d.member_no = oi_d.member_no
            AND mft_d.order_deal_date = oi_d.order_deal_date
    )
    SELECT DISTINCT
        mft.member_no,
        mft.brand_code,
        mft.store_code,
        CAST(SUM(oi.order_fact_amount) AS DECIMAL(18, 2)) AS consumption_amount,
        CAST(SUM(oi.order_fact_amount_include_coupon) AS DECIMAL(18, 2)) AS consumption_amount_include_coupon,
        CAST(SUM(oi.order_item_quantity) AS INTEGER) AS consumption_item_quantity,
        mft.order_deal_date AS consumption_date,
        CAST(date_diff('day', mft.order_deal_date, localtimestamp) AS INTEGER) AS consumption_gap,
        localtimestamp
    FROM mft LEFT JOIN cdm_crm.order_info_detail oi
    ON mft.member_no = oi.member_no
        AND mft.brand_code = oi.brand_code
        AND mft.store_code = oi.store_code
        AND mft.order_deal_date = oi.order_deal_date
    GROUP BY mft.member_no, mft.brand_code, mft.store_code, mft.order_deal_date;
