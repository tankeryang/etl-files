INSERT INTO ads_crm.daliy_report_area_day
    SELECT
        drad.sales_area,
        drad.city,
        drad.store_code,
        drad.member_type,
        drad.sales_amount,
        drad.sales_amount_proportion,
        drad.sales_amount_proportion_total,
        drad.last_year_same_time_sales_amount,
        drad.like_for_like_sales_growth,
        drad.sales_item_quantity,
        drad.discount_rate,
        drad.member_amount,
        drad.past_12_month_remain_member_amount,
        drad.second_trade_rate,
        drad.new_vip_member_amount,
        drad.new_normal_member_amount,
        drad.upgraded_member_amount,
        drad.store_amount,
        drad.member_amount_per_store,
        drad.sales_amount_per_person,
        drad.sales_item_quantity_per_person,
        drad.su_per_person,
        drad.order_amount_per_member,
        drad.order_deal_date
    FROM
        cdm_crm.daliy_report_area_day drad
    WHERE
        drad.order_deal_date > (SELECT max(order_deal_date) FROM ads_crm.daliy_report_area_day);
