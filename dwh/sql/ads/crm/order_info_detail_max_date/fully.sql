DELETE FROM ads_crm.order_info_detail_max_date;


INSERT INTO ads_crm.order_info_detail_max_date
    SELECT
        date(localtimestamp) - interval '1' day                           AS max_date,
        DATE_FORMAT(date(localtimestamp) - interval '1' day, '%Y-%m-%d')  AS vchr_max_date,
        CAST(month(date(localtimestamp) - interval '1' month) AS VARCHAR) AS last_month;
