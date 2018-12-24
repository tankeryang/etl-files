DELETE FROM ads_crm.member_register_detail;


INSERT INTO ads_crm.member_register_detail
    SELECT
        country,
        sales_area,
        sales_district,
        province,
        city,
        member_register_store,
        store_code,
        brand_name,
        sales_mode,
        store_type,
        store_level,
        channel_type,
        array_agg(member_no)       AS register_member_array,
        date(member_register_time) AS date
    FROM cdm_crm.member_info_detail
    GROUP BY
        country,
        sales_area,
        sales_district,
        province,
        city,
        member_register_store,
        store_code,
        brand_name,
        sales_mode,
        store_type,
        store_level,
        channel_type,
        date(member_register_time);
