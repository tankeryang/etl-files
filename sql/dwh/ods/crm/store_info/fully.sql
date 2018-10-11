DELETE FROM ods_crm.store_info;


INSERT INTO ods_crm.store_info
    SELECT
        store_id,
        store_no   AS store_code,
        store_name,
        channel_type,
        store_type,
        operation_state,
        brand_code,
        business_mode,
        country,
        region     AS sales_area,
        province,
        city,
        district,
        localtimestamp
    FROM dev_mysql_fpsit.crm.store_info;
