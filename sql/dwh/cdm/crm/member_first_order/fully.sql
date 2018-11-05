DELETE FROM cdm_crm.member_first_order;


INSERT INTO cdm_crm.member_first_order
    WITH mft AS (
        SELECT
            member_no,
            brand_code,
            min(order_deal_time) AS order_deal_time
        FROM ods_crm.order_info
        GROUP BY member_no, brand_code
    )
    SELECT DISTINCT
        mft.member_no,
        mft.brand_code,
        cast(sum(oi.order_fact_amount) AS DECIMAL(18, 2)),
        mft.order_deal_time
    FROM mft LEFT JOIN ods_crm.order_info oi
    ON mft.member_no = oi.member_no
    AND mft.brand_code = oi.brand_code
    AND mft.order_deal_time = oi.order_deal_time
    GROUP BY mft.member_no, mft.brand_code, mft.order_deal_time;
