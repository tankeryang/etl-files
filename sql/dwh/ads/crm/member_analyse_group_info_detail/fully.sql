DELETE FROM ads_crm.member_analyse_group_info_detail;


INSERT INTO ads_crm.member_analyse_group_info_detail
    SELECT
        mid.brand_code,
        mid.brand_name,
        mid.member_no,
        mid.member_birthday,
        cast(day((date(localtimestamp) - mid.member_birthday) / 365) AS INTEGER) AS member_age,
        mid.member_register_time,
        mid.reg_source,
        mid.member_grade_id,
        mlo.order_deal_time AS last_order_deal_time,
        mlo.order_fact_amount AS last_order_fact_amount,
        cast(day(date(localtimestamp) - date(mlo.order_deal_time)) AS INTEGER) AS last_order_deal_time_gap_with_today,
        mfo.order_deal_time AS first_order_deal_time,
        mfo.order_fact_amount AS first_order_fact_amount,
        cast(day(date(localtimestamp) - date(mfo.order_deal_time)) AS INTEGER) AS first_order_deal_time_gap_with_today,
        
    FROM cdm_crm.member_info_detail mid
    LEFT JOIN cdm_crm.member_last_order mlo ON mid.brand_code = mlo.brand_code AND mid.member_no = mlo.member_no

