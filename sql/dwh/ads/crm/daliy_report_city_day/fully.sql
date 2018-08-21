INSERT INTO ads_crm.daliy_report_city_day
    SELECT
        drcd.sales_area,
        drcd.city,
        drcd.store_code,
        drcd.member_type,
        drcd.sales_amount,
        drcd.sales_amount_proportion,
        drcd.sales_amount_proportion_total,
        drcd.last_year_same_time_sales_amount,
        drcd.like_for_like_sales_growth,
        drcd.sales_item_quantity,
        drcd.discount_rate,
        drcd.member_amount,
        drcd.past_12_month_remain_member_amount,
        drcd.second_trade_rate,
        drcd.new_vip_member_amount,
        drcd.new_normal_member_amount,
        drcd.upgraded_member_amount,
        drcd.store_amount,
        drcd.member_amount_per_store,
        drcd.sales_amount_per_person,
        drcd.sales_item_quantity_per_person,
        drcd.su_per_person,
        drcd.order_amount_per_member,
        drcd.order_deal_date
    FROM
        cdm_crm.daliy_report_city_day drcd;
