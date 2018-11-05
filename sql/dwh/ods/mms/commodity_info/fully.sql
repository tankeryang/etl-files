DELETE FROM ods_mms.commodity_info;


INSERT INTO ods_mms.commodity_info
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
        cast(retail_price AS DECIMAL(18, 2))
    FROM prod_mysql_mms.mms.commodity_info;
