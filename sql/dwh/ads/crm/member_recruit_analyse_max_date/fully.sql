DELETE FROM ads_crm.member_recruit_analyse_max_date;


INSERT INTO ads_crm.member_recruit_analyse_max_date
    SELECT
        date(localtimestamp) - interval '1' day                           AS max_date,
        date_format(date(localtimestamp) - interval '1' day, '%Y-%m-%d')  AS vchr_max_date
        cast(month(date(localtimestamp) - interval '1' month) AS VARCHAR) AS last_month;
