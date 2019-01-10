DELETE FROM ads_crm.member_cumulative_consumption_daily_detail;


INSERT INTO ads_crm.member_cumulative_consumption_daily_detail
    SELECT
        member_no,
        brand_code,
        ARRAY_DISTINCT(ARRAY_AGG(
            CASE
                WHEN store_code LIKE '%WWW%' THEN '官网'
                WHEN store_code IS NULL THEN '其他'
            ELSE store_code END
        )),
        CAST(COUNT(DISTINCT consumption_order_no) AS INTEGER),
        CAST(SUM(consumption_item_quantity) AS INTEGER),
        CAST(SUM(retail_amount) AS DECIMAL(18 ,2)),
        CAST(SUM(consumption_amount) AS DECIMAL(18 ,2)),
        CAST(SUM(consumption_amount_include_coupon) AS DECIMAL(18 ,2)),
        CAST(COUNT(DISTINCT return_order_no) AS INTEGER),
        CAST(SUM(return_amount) AS DECIMAL(18, 2)),
        consumption_date,
        DATE_FORMAT(consumption_date, '%Y-%m'),
        DATE_FORMAT(consumption_date, '%Y-%m-%d')
    FROM cdm_crm.member_cumulative_consumption
    WHERE (
        (consumption_order_no IS NOT NULL AND return_order_no IS NOT NULL) OR
        (consumption_order_no IS NULL AND return_order_no IS NOT NULL) OR
        (consumption_order_no IS NOT NULL AND return_order_no IS NULL)
    )
    GROUP BY member_no, brand_code, consumption_date;
