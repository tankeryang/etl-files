INSERT INTO cdm_crm.member_structure_asset_duration_potential_reg_source (
    computing_until_month,
    computing_duration,
    member_no,
    reg_source,
    channel_type,
    sales_area,
    store_region
    )
    WITH
        --潜在客户-注册来源
        duration_potential_reg_source AS (
            SELECT
            date_format(DATE('{c_date}') + INTERVAL '-1' MONTH, '%Y-%m') AS computing_until_month,
            CAST('{computing_duration}' AS INTEGER)                  AS computing_duration,
            mi.member_no,
            mi.member_reg_source,
            si.channel_type,
            si.sales_area,
            si.city                                                  AS store_region
            FROM ods_crm.member_info mi, ods_crm.store_info si
            WHERE mi.member_register_store = si.store_code AND
                mi.member_register_time >= date_trunc('month', DATE('{c_date}') +
                                                                                            INTERVAL '-{computing_duration}' MONTH) AND mi.member_register_time < date_trunc(
                'month', DATE('{c_date}')) AND
                mi.member_no NOT IN (
                    SELECT DISTINCT member_no
                    FROM ods_crm.order_info
                )
        )
    SELECT *
    FROM duration_potential_reg_source;