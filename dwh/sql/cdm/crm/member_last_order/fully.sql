DELETE FROM cdm_crm.member_last_order;


INSERT INTO cdm_crm.member_last_order
    WITH mlt AS (
        SELECT
            member_no,
            brand_code,
            MAX(order_deal_time) AS order_deal_time
        FROM ods_crm.order_info
        GROUP BY member_no, brand_code
    )
    SELECT DISTINCT
        mlt.member_no,
        mlt.brand_code,
        CAST(SUM(oi.order_fact_amount) AS DECIMAL(18, 2)),
        mlt.order_deal_time
    FROM mlt LEFT JOIN ods_crm.order_info oi
    ON mlt.member_no = oi.member_no
    AND mlt.brand_code = oi.brand_code
    AND mlt.order_deal_time = oi.order_deal_time
    GROUP BY mlt.member_no, mlt.brand_code, mlt.order_deal_time;
