INSERT INTO ads_crm.daliy_report_store_day
    SELECT
        drsd.sales_area,
        drsd.city,
        drsd.store_code,
        drsd.member_type,
        drsd.sales_amount,
        drsd.sales_amount_proportion,
        drsd.sales_amount_proportion_total,
        drsd.last_year_same_time_sales_amount,
        drsd.like_for_like_sales_growth,
        drsd.sales_item_quantity,
        drsd.discount_rate,
        drsd.member_amount,
        drsd.past_12_month_remain_member_amount,
        drsd.second_trade_rate,
        drsd.new_vip_member_amount,
        drsd.new_normal_member_amount,
        drsd.upgraded_member_amount,
        drsd.store_amount,
        drsd.member_amount_per_store,
        drsd.sales_amount_per_person,
        drsd.sales_item_quantity_per_person,
        drsd.su_per_person,
        drsd.order_amount_per_member,
        drsd.order_deal_date
    FROM
        cdm_crm.daliy_report_store_day drsd
    WHERE
        drsd.order_deal_date > (SELECT max(order_deal_date) FROM ads_crm.daliy_report_store_day);
