DELETE FROM ods_crm.commodity_info;


INSERT INTO ods_crm.commodity_info
    SELECT
        product_code,
        product_name,
        brand,
        main_cate,
        sub_cate,
        leaf_cate,
        series,
        lining,
        list_date,
        CAST(retail_price AS DECIMAL(18, 2))
    FROM prod_mysql_mms.mms.commodity_info;
