DELETE FROM ads_crm.order_info_detail;


INSERT INTO ads_crm.order_info_detail
    SELECT
        *,
        DATE_FORMAT(order_deal_date, '%Y-%m')    AS year_month,
        DATE_FORMAT(order_deal_date, '%Y-%m-%d') AS vchr_date
    FROM cdm_crm.order_info_detail;
