INSERT INTO ods_crm.store_info
  SELECT
    store_id,
    store_no   AS store_code,
    store_name,
    channel_type,
    region     AS sales_area,
    province,
    city,
    district,
    localtimestamp
  FROM prod_mysql_crm.crm.store_info;
